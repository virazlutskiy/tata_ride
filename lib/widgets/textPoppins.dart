import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextPoppins extends StatelessWidget{

  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final Color color;
  final int maxLines;
  final TextAlign textAlign;
  const TextPoppins({
    this.text='EMPTY TEXT',
    this.fontWeight=FontWeight.w500,
    this.fontSize = 16.0,
    this.color = Colors.red,
    this.maxLines = 1,
    this.textAlign = TextAlign.center
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      style: GoogleFonts.poppins(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      )
    );
  }
}