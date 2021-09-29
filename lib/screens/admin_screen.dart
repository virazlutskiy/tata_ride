import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:tata_ride/widgets/admin_row.dart';
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required FirebaseAuth this.auth}) : super(key: key);

  final String restaurant = '';
  final FirebaseAuth auth;
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressControllerA = TextEditingController();
  TextEditingController addressControllerB = TextEditingController();
  String driverToken = '';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  Future<void> addOrder() {
    // Call the user's CollectionReference to add a new user
    return orders
        .add({
      'name': widget.nameController.text, // John Doe
      'phone': widget.phoneController.text,
      'addressA':widget.addressControllerA.text,
      'addressB':widget.addressControllerB.text,
      'driver': widget.driverToken,
      'status':'Waiting'
    })
        .then((value) => {
      print("Order Added"),
      widget.nameController.clear(),
      widget.phoneController.clear(),
      widget.addressControllerA.clear(),
      widget.addressControllerB.clear(),
    })
        .catchError((error) => print("Failed to add order: $error"));
  }
  setDriverName(String name){
    widget.driverToken = name;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
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
              RestaurantInputRow(text:'Name',controller: widget.nameController,),
              RestaurantInputRow(text:'Phone',controller: widget.phoneController,),
              RestaurantInputRow(text:'Address A',controller: widget.addressControllerA,),
              RestaurantInputRow(text:'Address B',controller: widget.addressControllerB,),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .
                    //todo добавить поддежрку разных ресторанов
                    snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  var data = snapshot.data!.docs;
                  var drivers = [];
                  for (int index = 0; index < data.length; index++) {
                    if (data[index]['role'] == 'driver' && data[index]['status'] == 'Free') {
                      drivers.add(data[index]);
                    }
                  }
                  data.clear();

                  return Container(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                        child: Admin_row(
                          'Driver',
                          drivers,
                            setDriverName
                        ),
                    ),
                  );
                },
              ),
              BookNowButton(
                onPressed: (){

                  if(widget.nameController.text.isNotEmpty &&
                      widget.phoneController.text.isNotEmpty &&
                      widget.addressControllerA.text.isNotEmpty &&
                      widget.driverToken != '' &&
                      widget.addressControllerB.text.isNotEmpty)
                  {
                    addOrder();
                    //print('addUser done');
                  }
                  else
                  {
                    print('Wrong input');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
