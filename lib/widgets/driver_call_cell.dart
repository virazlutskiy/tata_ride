import 'package:tata_ride/widgets/textPoppins.dart';
import 'package:flutter/cupertino.dart';
import 'package:tata_ride/theme/colors.dart' as color;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverCallCell extends StatelessWidget{
  final String text;
  final String number;
  const DriverCallCell({this.text='',this.number=''});


  @override
  Widget build(BuildContext context) {
    return InkWell(
      //todo Добавить настройку для IOS из описания url_launcher
      onTap: () async {
        var _url = 'tel:' + number;
        if (await canLaunch(_url)) {
          launch(_url);
        } else {
          throw 'Could not launch $_url';
        }
      },
      child: Row(
        children: [
          TextPoppins(text: text,fontWeight: FontWeight.w400,fontSize: 24.0,color: color.Grayscale_Text),
          Container(width: 4,),
          Icon(Icons.call,color: color.Primary,size: 14,),
        ],
      ),
    );
  }
}
