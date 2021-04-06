import 'package:flutter/material.dart';

class ResetButton extends StatelessWidget {
  ResetButton(
      {this.onPressed,
      this.fontSize,
      this.calcTitle,
      this.btnHeight,
      this.btnWidth});

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
        border: Border.all(color: Color(0xFFD31145)),
        borderRadius: BorderRadius.circular(2.5),
      ),
      child: FlatButton(
        padding: EdgeInsets.symmetric(horizontal: 10),
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
