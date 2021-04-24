import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  PasswordField(
      {this.hintText,
      this.tec,
      this.extraPad,
      this.fontSize,
      this.iconSize,
      this.ctnPadding,
      this.fieldWidth,
      this.fieldHeight});

  final String hintText;
  final TextEditingController tec;
  final double fieldHeight;
  final double fieldWidth;
  final double ctnPadding;
  final double fontSize;
  final double iconSize;
  final double extraPad;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: fieldHeight,
        width: fieldWidth,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2.5),
            boxShadow: [
              BoxShadow(
                  offset: Offset(3, 6),
                  color: Colors.black.withOpacity(0.16),
                  spreadRadius: 5,
                  blurRadius: 10)
            ]),
        child: Center(
          child: TextField(
            controller: tec,
            keyboardType: TextInputType.name,
            obscureText: true,
            style: TextStyle(
                fontSize: fontSize, color: Colors.black, fontFamily: "Kano"),
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                  fontFamily: "Kano",
                  fontSize: fontSize,
                  color: Color(0xFFBBBBBB)),
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                size: iconSize,
                color: Color(0xFFBBBBBB),
              ),
            ),
          ),
        ));
  }
}
