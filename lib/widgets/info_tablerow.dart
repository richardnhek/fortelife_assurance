import 'package:flutter/material.dart';

class InfoTableRow extends TableRow {
  InfoTableRow({this.leadingString, this.trailingString});

  final String leadingString;
  final String trailingString;

  @override
  // TODO: implement children
  List<Widget> get children => [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            leadingString,
            style: TextStyle(
                fontFamily: "Kano", fontSize: 15, color: Colors.black),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            trailingString,
            style: TextStyle(
                fontFamily: "Kano", fontSize: 15, color: Colors.black),
          ),
        )
      ];
}
