import 'package:flutter/material.dart';

class CalculateButton extends StatelessWidget {
  CalculateButton(
      {this.onPressed,
      this.btnHeight,
      this.btnWidth,
      this.calcTitle,
      this.fontSize});

  final Function onPressed;
  final double btnHeight;
  final double btnWidth;
  final String calcTitle;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: btnWidth,
      height: btnHeight,
      decoration: BoxDecoration(
          color: Color(0xFF8AB84B),
          borderRadius: BorderRadius.circular(2.5),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 5)
          ]),
      child: FlatButton(
        padding: EdgeInsets.all(10),
        onPressed: onPressed,
        child: Text(
          calcTitle,
          style: TextStyle(
              fontSize: fontSize,
              fontFamily: "Kano",
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
