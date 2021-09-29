import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tata_ride/theme/colors.dart' as color;

class LoadingScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/restaurant.png"),
              ),
            ),
          ),
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(color.Primary),
              strokeWidth: 5,
            ),
          ),
        ],
      ),
    );
  }

}