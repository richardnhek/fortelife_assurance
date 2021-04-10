import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';
import 'package:provider/provider.dart';

class CustomDatePicker extends StatelessWidget {
  CustomDatePicker(
      {this.focusNode,
      this.dob,
      this.onTap,
      this.title,
      this.mq,
      this.appProvider});

  final FocusNode focusNode;
  final TextEditingController dob;
  final Function onTap;
  final String title;
  final AppProvider appProvider;
  final MediaQueryData mq;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Color(0xFFB8B8B8))),
      child: Center(
        child: TextField(
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.only(left: 5, bottom: 5),
              hintText: title,
              labelText: title,
              labelStyle: TextStyle(
                  fontFamily: "Kano",
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.5)),
              hintStyle: TextStyle(
                  fontFamily: "Kano",
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.5))),
          focusNode: focusNode,
          style:
              TextStyle(color: Colors.black, fontSize: 15, fontFamily: "Kano"),
          controller: dob,
          onTap: onTap,
        ),
      ),
    );
  }
}
