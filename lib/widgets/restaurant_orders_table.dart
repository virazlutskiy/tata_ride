import 'package:tata_ride/widgets/textPoppins.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tata_ride/theme/colors.dart' as color;
import 'package:tata_ride/screens/restaurant_screen.dart' as rs;
import 'order_status.dart';
class RestaurantOrdersTable extends StatelessWidget{
  final String restaurant;
  final void Function(int) callback;
  RestaurantOrdersTable({required this.restaurant,required this.callback });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("orders").
      //todo добавить поддежрку разных ресторанов
      where('restaurant', isEqualTo: restaurant).
      orderBy('orderNum', descending: true).
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
        int lastOrderNum = 0;
        return ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: data == null ? 1 : data.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              // return the header
              return new Row(
                children: [
                  Expanded(
                      flex:1,
                      child: TextPoppins(text: 'ORDER NO.',fontWeight: FontWeight.w400,fontSize: 12,color: color.Grayscale_Text2,)),
                  Expanded(
                      flex:1,
                      child: TextPoppins(text: 'NAME',fontWeight: FontWeight.w400,fontSize: 12,color: color.Grayscale_Text2,)),
                  Expanded(
                      flex:1,
                      child: TextPoppins(text: 'STATUS',fontWeight: FontWeight.w400,fontSize: 12,color: color.Grayscale_Text2,)),

                ],
              );
            }
            index -= 1;

            //Ищем последний доступный ордер
            if(lastOrderNum<data[index]['orderNum']) {lastOrderNum=data[index]['orderNum'];}
            //Если больше ордеров нет, то возвращаем самый последний номер
            if(index == data.length-1) {callback(lastOrderNum+1);}

            return Row(
              children: [
                Expanded(child:TextPoppins(text: data[index]['orderNum'].toString(),fontWeight: FontWeight.w700,fontSize: 14,color: color.Grayscale_Text,)),
                Expanded(child:TextPoppins(text:data[index]['name'],)),
                Expanded(child:OrderStatus(status: data[index]['status'])),
              ],
            );
          },
        );;
      },
    );
  }

}