import 'package:tata_ride/widgets/textPoppins.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tata_ride/theme/colors.dart' as color;
class BookNowButton extends StatelessWidget{
  final VoidCallback? onPressed;
  final String text;
  BookNowButton({required this.onPressed,this.text='BOOK NOW'});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28.0,28,28,28),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: color.Primary,
          padding: EdgeInsets.fromLTRB(50,16,50,16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
        ),
        child: TextPoppins(text:this.text,fontWeight: FontWeight.w700,fontSize: 16,color: color.Grayscale_White,),
      ),
    );
  }
}