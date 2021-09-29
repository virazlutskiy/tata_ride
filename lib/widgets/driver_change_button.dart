import 'package:tata_ride/widgets/textPoppins.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tata_ride/theme/colors.dart' as color;

import 'change_order_state_dialog.dart';

class DriverChangeButton extends StatelessWidget{
  final String tittle;
  final String id;
  final String state;
  const DriverChangeButton({this.tittle='',required this.id,required this.state});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
            onPressed:  ()async {
              await showDialog(context: context,
                builder: (BuildContext context)
                {
                  return CustomDialogBox(title: tittle,id:id,state: state,);
                }
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: Color.fromRGBO(203, 184, 255, 1),
            padding: EdgeInsets.fromLTRB(12,2,12,2),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)),
          ),
          child: TextPoppins(text:'Change',fontWeight: FontWeight.w700,fontSize: 10,color: color.Secondary,),
        ),
      ),
    );
  }

}