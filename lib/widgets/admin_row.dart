import 'package:tata_ride/widgets/textPoppins.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tata_ride/theme/colors.dart' as color;
import 'package:google_fonts/google_fonts.dart';

class Admin_row extends StatefulWidget {
  String restaurantName = '';
  var driver;
  String selected = '';
  String originalValue = '';
  List drivers = [];
  var setDriverName;
  Admin_row(restaurantName, List drivers, Function(String name) setDriverName) {
    this.restaurantName = restaurantName;
    this.drivers = drivers;
    this.setDriverName = setDriverName;
    this.driver = drivers.firstWhere(
        (i) => i['status'].toString() == 'Free', orElse: () {
      return null;
    });
    if (this.driver != null) {
      this.selected = driver['key'].toString();
    } else {
      this.selected = '';
    }

    originalValue = this.selected;
  }

  @override
  State<StatefulWidget> createState() {
    return _AdminRowState();
  }
}

class _AdminRowState extends State<Admin_row> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextPoppins(
          text: 'Driver', //restaurants[index]['restaurant'].toString(),
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: color.Grayscale_Text,
        ),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: color.Grayscale_StrokeLine),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: widget.selected,
                    icon: const Icon(Icons.arrow_drop_down_rounded,
                        color: color.Grayscale_StrokeLine),
                    iconSize: 24,
                    elevation: 16,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: color.Grayscale_Text,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.selected = newValue ?? 'None';
                        widget.setDriverName(newValue);
                      });
                    },
                    items: [DropdownMenuItem<String>(
                            value: '',
                            child: Text('No Driver'),
                          )] +
                        widget.drivers
                            .map((e) => DropdownMenuItem<String>(
                                  value: e['key'].toString(),
                                  child: Text(e['name'].toString()),
                                ))
                            .toList(),
                  ),
                ),
              ),
            ),
            /*Spacer(),
            Expanded(
              flex: 2,
              child: TextButton(
                onPressed: (widget.originalValue != widget.selected)
                    ? () {
                        var newdriver = widget.drivers.firstWhere(
                            (i) => i['name'].toString() == widget.selected);

                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(newdriver.id)
                            .update({
                          'status': widget.restaurantName,
                        });
                        if(widget.driver!= null) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.driver.id)
                              .update({
                            'restaurant': '',
                          });
                        }
                      }
                    : null,
                style: TextButton.styleFrom(
                  backgroundColor: (widget.originalValue != widget.selected)
                      ? color.Primary
                      : color.Secondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: TextPoppins(
                  text: 'Assign',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: color.Grayscale_White,
                ),
              ),
            )
            */
          ],
        ),
      ],
    );
  }
}
