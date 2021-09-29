import 'package:tata_ride/widgets/textPoppins.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tata_ride/theme/colors.dart' as color;

class ChangeOrderStateDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        child: Text('Hi!'),
      ),
    );
  }
}

class CustomDialogBox extends StatefulWidget {
  final String title;
  final String id;
  final String state;
  const CustomDialogBox({required this.title,required this.id,required this.state});

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextPoppins(
              text: this.widget.title,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color.Grayscale_HeadingTitle,
            ),
          ),
          Divider(
            color: color.Grayscale_StrokeLine,
            height: 1,
          ),
          (widget.state=='Waiting')?Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 4),
            child: Container(
              height: 48,
              width: 260,
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: color.State_Picked,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  onTap: () {
                    FirebaseFirestore.instance.collection('orders').doc(widget.id).update({
                      'status': 'Picked',
                    });
                    Navigator.of(context).pop();
                  },
                  child: Stack(
                    children: [
                      Center(
                          child: TextPoppins(
                        text: 'Picked Up',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: color.Grayscale_White,
                      )),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: color.Background,
                            ),
                            height: 46,
                            width: 44,
                            child: Center(
                                child: Image.asset(
                              'assets/truck_pickedup.png',
                              height: 24,
                              width: 24,
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ):Text(''),
          (widget.state=='Picked')?Padding(
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 32),
            child: Container(
              height: 48,
              width: 260,
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: color.State_Complete,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  onTap: () {
                    FirebaseFirestore.instance.collection('orders').doc(widget.id).update({
                      'status': 'Complete',
                    });
                    Navigator.of(context).pop('Complete');
                  },
                  child: Stack(
                    children: [
                      Center(
                          child: TextPoppins(
                        text: 'Complete',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: color.Grayscale_White,
                      )),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: color.Background,
                            ),
                            height: 46,
                            width: 44,
                            child: Center(
                                child: Image.asset(
                              'assets/truck_complete.png',
                              height: 24,
                              width: 24,
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ):Text(''),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    primary: color.Primary,
                    backgroundColor: color.Primary,
                    shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),

                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(84,4,84,4),
                    child: TextPoppins(text: 'OK',fontSize: 16,fontWeight: FontWeight.w700,color: color.Grayscale_White,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
