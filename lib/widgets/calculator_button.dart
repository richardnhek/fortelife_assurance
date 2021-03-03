import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  CalculatorButton(
      {this.calculatorTitle,
      this.calculatorImg,
      this.calculatorDesc,
      this.calculatorOnTap});

  final String calculatorTitle;
  final AssetImage calculatorImg;
  final String calculatorDesc;
  final Function calculatorOnTap;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: calculatorOnTap,
      disabledColor: Colors.transparent,
      color: Colors.transparent,
      highlightColor: Colors.transparent,
      elevation: 3.5,
      highlightElevation: 15,
      padding: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.all(10),
        height: 140,
        width: 140,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  spreadRadius: 0.5,
                  blurRadius: 10,
                  offset: Offset(3, 6))
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(calculatorTitle,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Kano",
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6ABFBC))),
            Image(
              image: calculatorImg,
              width: 60,
              height: 60,
            ),
            Text(
              calculatorDesc,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Kano",
                  fontStyle: FontStyle.italic,
                  color: Colors.black.withOpacity(0.5)),
            )
          ],
        ),
      ),
    );
  }
}
