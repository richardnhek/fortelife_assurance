import 'package:flutter/material.dart';

class FieldTitle extends StatelessWidget {
  FieldTitle({this.fieldTitle, this.fontSize});

  final String fieldTitle;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        fieldTitle,
        style: TextStyle(
            fontFamily: "Kano",
            fontSize: fontSize,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
