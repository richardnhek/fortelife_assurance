import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';

class InfoTableRow extends TableRow {
  InfoTableRow(
      {this.leadingString, this.trailingString, this.appProvider, this.mq});

  final String leadingString;
  final String trailingString;
  final MediaQueryData mq;
  final AppProvider appProvider;

  @override
  // TODO: implement children
  List<Widget> get children => [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            leadingString,
            style: TextStyle(
                fontFamily: "Kano",
                fontSize: DeviceUtils.getResponsive(
                    mq: mq,
                    appProvider: appProvider,
                    onPhone: 15.0,
                    onTablet: 30.0),
                color: Colors.black),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            trailingString,
            style: TextStyle(
                fontFamily: "Kano",
                fontSize: DeviceUtils.getResponsive(
                    mq: mq,
                    appProvider: appProvider,
                    onPhone: 15.0,
                    onTablet: 30.0),
                color: Colors.black),
          ),
        )
      ];
}
