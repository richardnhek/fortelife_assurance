import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  CustomDatePicker({this.focusNode, this.dob, this.onTap});

  final FocusNode focusNode;
  final TextEditingController dob;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Color(0xFFB8B8B8))),
      child: TextField(
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.only(left: 5, top: 10, bottom: 10),
            hintText: "Date of Birth",
            labelText: "Date of Birth",
            labelStyle: TextStyle(
                fontFamily: "Kano",
                fontSize: 15,
                color: Colors.black.withOpacity(0.5)),
            hintStyle: TextStyle(
                fontFamily: "Kano",
                fontSize: 15,
                color: Colors.black.withOpacity(0.5))),
        focusNode: focusNode,
        style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: "Kano"),
        controller: dob,
        onTap: onTap,
      ),
    );
  }
}
