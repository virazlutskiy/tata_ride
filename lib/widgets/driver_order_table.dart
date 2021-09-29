import 'package:tata_ride/widgets/driver_change_button.dart';
import 'package:tata_ride/widgets/textPoppins.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tata_ride/theme/colors.dart' as color;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'driver_call_cell.dart';
import 'order_status.dart';
class DriverOrdersTable extends StatelessWidget{
  final String restaurant;
  DriverOrdersTable({this.restaurant = ''});
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
          return Expanded(
            child: ListView.builder(
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
                      Expanded(
                          flex:1,
                          child: Text(''))
                    ],
                  );
                }
                index -= 1;

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child:TextPoppins(text: data[index]['orderNum'].toString(),fontWeight: FontWeight.w700,fontSize: 14,color: color.Grayscale_Text,)),
                        Expanded(child:DriverCallCell(text:data[index]['name'],number: data[index]['phone'],)),
                        Expanded(child:OrderStatus(status: data[index]['status'])),
                        Expanded(child:DriverChangeButton(tittle: data[index]['name'],id:data[index].id,state: data[index]['status'],)),
                      ],
                    ),
                    (data[index]['status']!='Complete')?
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: TextPoppins(
                        text: data[index].get('address')??''.toString(),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: color.Grayscale_Text2,
                        textAlign: TextAlign.start,
                        maxLines: 10,
                      ),
                    ):
                    Container(),
                  ],
                );
              },
            ),
          );;
        },
      );
      //todo Добавить сортировку
      //todo Использовать ЛистВью
      /*
      Expanded(
            child: ListView.builder(
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
                      Expanded(
                          flex:1,
                          child: Text(''))
                    ],
                  );
                }
                index -= 1;

                return Row(
                  children: [
                    Expanded(child:TextPoppins(text: '111',fontWeight: FontWeight.w700,fontSize: 14,color: color.Grayscale_Text,)),
                    Expanded(child:DriverCallCell(text:data[index]['name'],number: '+7 900 000 1234',)),
                    Expanded(child:OrderStatus(status: 'Waiting')),
                    Expanded(child:DriverChangeButton()),
                  ],
                );
              },
            ),
          );
       */
  }

}