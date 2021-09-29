import 'package:tata_ride/widgets/book_now_button.dart';
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
  MyHomePage({Key? key,required this.restaurant, required this.auth }) : super(key: key);
  final FirebaseAuth auth;
  final String restaurant;
  int nextOrderNum = 0;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  //todo подумать над возвращением с колбэка. Возможно стоит запрашивать последний ордернам
  void callback(int num){
    this.nextOrderNum = num;
    //print(this.nextOrderNum.toString());
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance.collection('orders');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
        'name': widget.nameController.text, // John Doe
        'orderNum': widget.nextOrderNum, // Stokes and Sons
        'phone': widget.phoneController.text,
        'restaurant': widget.restaurant,
        'status':'Waiting'
      })
          .then((value) => {
        print("Order Added"),
        widget.nameController.clear(),
        widget.phoneController.clear(),
        widget.addressController.clear(),
      })
          .catchError((error) => print("Failed to add order: $error"));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(height: 40,),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24,0,0,0),
                  child: IconButton(onPressed: (){
                    widget.auth.signOut();
                  }, icon: const Icon(Icons.logout,color: color.Primary,)),
                ),
                Center(child: Image(image: AssetImage('assets/logo.png'),height: 98,))
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,32,0,16),
              child: TextPoppins(text: 'New Order',fontWeight: FontWeight.w700,fontSize: 24.0,color: color.Grayscale_HeadingTitle),
            ),
            RestaurantInputRow(text:'Name',controller: widget.nameController,),
            RestaurantInputRow(text:'Phone',controller: widget.phoneController,),
            RestaurantInputRow(text:'Address',controller: widget.addressController,),
            BookNowButton(
              onPressed: addUser,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,16,0,16),
              child: TextPoppins(text: 'Orders',fontWeight: FontWeight.w700,fontSize: 24.0,color: color.Grayscale_HeadingTitle),
            ),
            RestaurantOrdersTable(restaurant: widget.restaurant,callback: widget.callback,),
          ],
        ),
      ),
    );
  }
}