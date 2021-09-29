import 'package:tata_ride/widgets/book_now_button.dart';
import 'package:tata_ride/widgets/driver_order_table.dart';
import 'package:tata_ride/widgets/restaurant_input_row.dart';
import 'package:tata_ride/widgets/restaurant_orders_table.dart';
import 'package:tata_ride/widgets/textPoppins.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tata_ride/theme/colors.dart' as color;
import 'package:tata_ride/screens/driver_screen.dart' as ds;
import 'package:tata_ride/screens/restaurant_screen.dart' as rs;

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key, required this.title}) : super(key: key);
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final String title;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(
        children: [
          Positioned(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/restaurant.png"),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(42),
                    topRight: Radius.circular(42)),
                color: color.Background,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 42, 0, 0),
                    child: TextPoppins(
                        text: 'Login',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: color.Grayscale_HeadingTitle),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
                    child: TextPoppins(
                        text: 'Let’s get started',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: color.Grayscale_HeadingTitle),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 26, 8, 0),
                    child: TextPoppins(
                        text: 'Email',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: color.Grayscale_Text),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: Container(
                      height: 46,
                      child: TextFormField(
                        //todo добавить валидацию данных
                        controller: widget.emailController,
                        obscureText: false,
                        cursorColor: color.Secondary,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: color.Grayscale_Text,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(193, 197, 208, 1),
                                width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: color.Secondary, width: 2.0),
                              borderRadius: BorderRadius.circular(8.0)),
                          labelText: '',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 0, 0),
                    child: TextPoppins(
                        text: 'Password',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: color.Grayscale_Text),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                    child: Container(
                      height: 46,
                      child: TextFormField(
                        //todo добавить валидацию данных
                        controller: widget.passwordController,
                        obscureText: false,
                        cursorColor: color.Secondary,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: color.Grayscale_Text,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(193, 197, 208, 1),
                                width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: color.Secondary, width: 2.0),
                              borderRadius: BorderRadius.circular(8.0)),
                          labelText: '',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                              onPressed: () async {
                                try {
                                  UserCredential userCredential = await widget
                                      .firebaseAuth
                                      .signInWithEmailAndPassword(
                                          email: widget.emailController.text,
                                          password:
                                              widget.passwordController.text);
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    print('No user found for that email.');
                                  } else if (e.code == 'wrong-password') {
                                    print(
                                        'Wrong password provided for that user.');
                                  }
                                }

                                //конец магии
                              },
                              style: TextButton.styleFrom(
                                primary: color.Primary,
                                backgroundColor: color.Primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextPoppins(
                                  text: 'Login',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: color.Grayscale_White,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
/*
    widget.firebaseAuth
        .authStateChanges()
        .listen((User? user) async {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        var data = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if(data['role']=='driver' && !loaded){
          loaded = true;
          //todo null safety
          print('!!!!!!!!!!!!!!!!');
          var ntmp = Navigator.of(context);

          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ds.MyHomePage(restaurant: data['restaurant'],auth:widget.firebaseAuth)));

        }else if(data['role']=='restaurant')
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => rs.MyHomePage(title: '')));
        }
      }
    });
    */
  }
}
