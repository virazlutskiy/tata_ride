import 'package:maps_launcher/maps_launcher.dart';
import 'package:tata_ride/widgets/textPoppins.dart';
import 'package:flutter/cupertino.dart';
import 'package:tata_ride/theme/colors.dart' as color;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverMapCell extends StatelessWidget{
  final String text;
  final String address;
  const DriverMapCell({this.text='',this.address=''});


  @override
  Widget build(BuildContext context) {
    return InkWell(
      //todo Добавить настройку для IOS из описания url_launcher
      onTap: ()  {
         MapsLauncher.launchQuery(
            address);
      },
      child: Row(
        children: [
          TextPoppins(text: text,fontWeight: FontWeight.w400,fontSize: 24.0,color: color.Grayscale_Text),
          Container(width: 4,),
          Icon(Icons.map,color: color.Primary,size: 14,),
        ],
      ),
    );
  }
}
