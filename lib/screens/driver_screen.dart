import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tata_ride/widgets/book_now_button.dart';
import 'package:tata_ride/widgets/driver_call_cell.dart';
import 'package:tata_ride/widgets/driver_map_cell.dart';
import 'package:tata_ride/widgets/driver_order_table.dart';
import 'package:tata_ride/widgets/restaurant_input_row.dart';
import 'package:tata_ride/widgets/restaurant_orders_table.dart';
import 'package:tata_ride/widgets/textPoppins.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tata_ride/theme/colors.dart' as color;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required FirebaseAuth this.auth}) : super(key: key);

  final FirebaseAuth auth;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 40,
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                  child: IconButton(
                      onPressed: () {
                        widget.auth.signOut();
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: color.Primary,
                      )),
                ),
                Center(
                    child: Image(
                  image: AssetImage('assets/logo.png'),
                  height: 98,
                ))
              ],
            ),
            Container(
              height: 300,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text("Something went wrong");
                    }
                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text("Document does not exist");
                    }

                    if (snapshot.hasData) {
                      if (snapshot.data!.get('order') == Null) {
                        return Text('No orders at the moment');
                      }
                      if (snapshot.data!.get('order') == '') {
                        return Text('Order field empty');
                      }
                      return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('orders')
                              .doc(snapshot.data!.get('order'))
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              return Text("Something went wrong2");
                            }
                            if (snapshot.hasData && !snapshot.data!.exists) {
                              return Text("Document does not exist2");
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(24,8,24,8),
                                child: Column(
                                  children: [
                                    Align(alignment: Alignment.centerLeft,child: TextPoppins(text: 'Name: '+snapshot.data!['name'],fontWeight: FontWeight.w500,fontSize: 24.0,color: color.Grayscale_Text)),
                                    DriverCallCell(text: 'Phone: ${snapshot.data!['phone']}',number: snapshot.data!['phone'],),
                                    DriverMapCell(text: 'Point A: '+snapshot.data!['addressA'],address: snapshot.data!['addressA'],),
                                    DriverMapCell(text: 'Point B: '+snapshot.data!['addressB'],address: snapshot.data!['addressB'],),
                                    BookNowButton(
                                      onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(FirebaseAuth.instance.currentUser!.uid).update(
                                              {
                                                'status': 'Free',
                                                'order':'',
                                              }
                                          );
                                          await FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(snapshot.data!.id).update(
                                              {
                                                'status':'Complete'
                                              }
                                          );
                                      },
                                        text:'Order complete'

                                    ),
                                  ],
                                ),
                              );
                              return Text(snapshot.data!['name']);
                            }
                            return Text('Loading2');
                          });
                    }
                    return Text('Loading1');
                  }),
            ),
            /*
            Padding(
              padding: const EdgeInsets.fromLTRB(0,32,0,16),
              child: TextPoppins(text: 'Orders List',fontWeight: FontWeight.w700,fontSize: 24.0,color: color.Grayscale_HeadingTitle),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,34,0,24),
              child: TextPoppins(text: 'Orders',fontWeight: FontWeight.w700,fontSize: 24.0,color: color.Grayscale_HeadingTitle),
            ),
            DriverOrdersTable(restaurant:widget.restaurant),
            */
          ],
        ),
      ),
    );
  }
}
