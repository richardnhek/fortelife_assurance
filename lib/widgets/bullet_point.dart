import 'package:flutter/material.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class BulletPoint extends StatelessWidget {
  BulletPoint({this.bulletTitle});

  final String bulletTitle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: ListTileMoreCustomizable(
        leading: Container(
          height: 10.0,
          width: 10.0,
          decoration: new BoxDecoration(
            color: Color(0xFF8AB84B),
            shape: BoxShape.circle,
          ),
        ),
        dense: true,
        minLeadingWidth: 20,
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.all(5),
        title: Text(
          bulletTitle,
          style:
              TextStyle(fontFamily: "Kano", fontSize: 15, color: Colors.black),
        ),
      ),
    );
  }
}
