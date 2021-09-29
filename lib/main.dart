import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tata_ride/screens/loading_screen.dart';
import 'package:tata_ride/screens/login_screen.dart';
import 'package:tata_ride/screens/restaurant_screen.dart' as restaurant_screen;
import 'package:tata_ride/screens/driver_screen.dart' as driver_screen;
import 'package:tata_ride/screens/admin_screen.dart' as admin_screen;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tata_ride/theme/colors.dart' as color;


Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance: NotificationImportance.High,
        )
      ]
  );
  runApp(App());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");

  // Use this method to automatically convert the push data, in case you gonna use our data standard
  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'New order for you!',
        body: '',
        payload: {'projectId':message.data['projectId']},
      ),
      actionButtons: [
        NotificationActionButton(
          label: 'Accept',
          enabled: true,
          buttonType: ActionButtonType.Default,
          key: 'accept',
        ),
        NotificationActionButton(
          label: 'Reject',
          enabled: true,
          buttonType: ActionButtonType.Default,
          key: 'reject',
        )
      ]
  );
  //AwesomeNotifications().createNotificationFromJsonData(message.data);
}

class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  late FirebaseMessaging messaging;

  get onDidReceiveLocalNotification => null;

  get onSelectNotification => null;


  @override
  initState(){
    print('init');
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    AwesomeNotifications().actionStream.listen(
            (receivedNotification) async {
                print('event received!');
                print(receivedNotification.toMap().toString());
                if(receivedNotification.toMap()['buttonKeyPressed'] == 'accept'){
                  var projectId = receivedNotification.toMap()['payload']['projectId'];
                  print(projectId);
                  await FirebaseFirestore.instance
                      .collection("orders")
                      .doc(projectId).update({'status':'Accept'});
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid).update({'order':projectId});
                }else if(receivedNotification.toMap()['buttonKeyPressed'] == 'reject')
                  {
                    var projectId = receivedNotification.toMap()['payload']['projectId'];
                    print(projectId);
                    await FirebaseFirestore.instance
                        .collection("orders")
                        .doc(projectId).update({'status':'Rejected'});
                  }
                // do something based on event...

        }
    );


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            print(snapshot.error);
            return Directionality(
                textDirection: TextDirection.rtl, child: Text('Error 1'));
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            ///////
            messaging = FirebaseMessaging.instance;
            print('Token: ' + messaging.getToken().toString());
            FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
            FirebaseMessaging.onMessage.listen((RemoteMessage message) {
              print("Handling a onMessage: ${message.messageId}");
              _firebaseMessagingBackgroundHandler(message);
            });
            //////

            return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.hasData) {
                    return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return Text("Document does not exist");
                          }

                          if (snapshot.connectionState == ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            if (data["role"] == 'driver') {
                              messaging.getToken().then((value) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                      .doc(FirebaseAuth.instance.currentUser!.uid).update({
                                        'token':value
                                      });
                                });
                              return driver_screen.MyHomePage(
                                  auth: FirebaseAuth.instance);
                            } else if (data["role"] == 'operator') {
                              print('restaurant');
                              return restaurant_screen.MyHomePage(
                                  restaurant: '',
                                  auth: FirebaseAuth.instance);
                            } else if (data["role"] == 'admin') {
                              print('admin');
                              return admin_screen.MyHomePage(
                                  auth: FirebaseAuth.instance);
                            }
                          }
                          return LoadingScreen();
                        });
                  }
                  return LoginScreen(title: '');
                },
              );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Directionality(
              textDirection: TextDirection.rtl,
              child: LoadingScreen());
        },
      ),
    );
  }
}
