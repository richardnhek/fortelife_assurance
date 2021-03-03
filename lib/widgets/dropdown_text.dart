import 'package:flutter/material.dart';

class DropDownText extends StatelessWidget {
  DropDownText({this.title});

  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: Colors.black, fontFamily: "Kano", fontSize: 15),
    );
  }
}
