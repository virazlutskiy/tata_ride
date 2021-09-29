import 'package:tata_ride/widgets/textPoppins.dart';
import 'package:flutter/cupertino.dart';
import 'package:tata_ride/theme/colors.dart' as color;

class OrderStatus extends StatelessWidget{
  final String status;
  const OrderStatus({this.status='Error'});

  Color colorOfStatus(){
    switch(status){
      case 'Waiting':
        return color.State_Waiting;
      case 'Picked':
        return color.State_Picked;
      case 'Complete':
        return color.State_Complete;
      default:
        return color.State_Error;
    }
  }
  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8.0,
          height: 8.0,
          decoration: new BoxDecoration(
            color: colorOfStatus(),
            shape: BoxShape.circle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextPoppins(text: status,fontWeight: FontWeight.w700,fontSize: 14,color: colorOfStatus(),),
        ),
      ],
    );
  }

}