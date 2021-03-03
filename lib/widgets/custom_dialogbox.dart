import 'package:flutter/material.dart';

class CustomDialogBox extends StatelessWidget {
  CustomDialogBox({this.dialogList});

  final List<Widget> dialogList;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: dialogList,
      ),
    );
  }
}
