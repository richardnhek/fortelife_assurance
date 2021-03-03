import 'package:flutter/material.dart';

class CalculateButton extends StatelessWidget {
  CalculateButton({this.onPressed});

  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Container(
      width: 100,
      height: mq.size.height / 16,
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
          "Calculate",
          style: TextStyle(
              fontSize: 15, fontFamily: "Kano", fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
