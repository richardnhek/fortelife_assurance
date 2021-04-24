import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';
import 'package:provider/provider.dart';

class CustomDialogText extends StatelessWidget {
  CustomDialogText({this.description});

  final String description;
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final mq = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Text(
        "- $description",
        style: TextStyle(
            color: Colors.black,
            fontFamily: "Kano",
            fontSize: DeviceUtils.getResponsive(
                appProvider: appProvider,
                mq: mq,
                onPhone: 15.0,
                onTablet: 30.0)),
      ),
    );
  }
}
