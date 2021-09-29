import 'package:tata_ride/widgets/textPoppins.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tata_ride/theme/colors.dart' as color;
import 'package:google_fonts/google_fonts.dart';

class RestaurantInputRow  extends StatelessWidget{
  final String text;
  final TextEditingController controller;
  RestaurantInputRow({this.text = '',required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24,8,24,8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextPoppins(text: text,fontWeight: FontWeight.w500,fontSize: 16.0,color: color.Grayscale_Text),
          Container(
            height: 46,
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextFormField(
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              obscureText: false,
              cursorColor: color.Secondary,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: color.Grayscale_Text,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromRGBO(193, 197, 208, 1), width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: color.Secondary, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0)
                ),
                labelText: '',
              ),
            ),
          )
        ],
      ),
    );
  }
}