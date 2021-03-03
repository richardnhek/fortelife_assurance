import 'package:flutter/material.dart';

class ResetButton extends StatelessWidget {
  ResetButton({this.onPressed});

  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Container(
      width: 100,
      height: mq.size.height / 16,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFD31145)),
        borderRadius: BorderRadius.circular(2.5),
      ),
      child: FlatButton(
        padding: EdgeInsets.symmetric(horizontal: 10),
        onPressed: onPressed,
        child: Text(
          "Reset",
          style: TextStyle(
              fontSize: 15, fontFamily: "Kano", fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
