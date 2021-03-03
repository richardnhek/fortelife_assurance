import 'package:flutter/material.dart';

class CustomDialogText extends StatelessWidget {
  CustomDialogText({this.description});

  final String description;
  @override
  Widget build(BuildContext context) {
    return Text(
      "- $description",
      style: TextStyle(color: Colors.black, fontFamily: "Kano", fontSize: 15),
    );
  }
}
