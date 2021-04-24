import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';
import 'package:provider/provider.dart';

class DropDownText extends StatelessWidget {
  DropDownText({this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final mq = MediaQuery.of(context);
    return Text(
      title,
      style: TextStyle(
          color: Colors.black,
          fontFamily: "Kano",
          fontSize: DeviceUtils.getResponsive(
              appProvider: appProvider, mq: mq, onPhone: 15.0, onTablet: 30.0)),
    );
  }
}
