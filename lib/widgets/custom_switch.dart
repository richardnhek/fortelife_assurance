import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  CustomSwitch({this.value, this.title, this.onChanged});

  final bool value;
  final Function onChanged;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SwitchListTile(
          title: Text(
            title,
            style: TextStyle(
                fontFamily: "Kano",
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black.withOpacity(0.5)),
          ),
          activeColor: Color(0xFF8AB84B),
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 5),
          value: value,
          onChanged: onChanged),
    );
  }
}
