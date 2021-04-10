import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class BulletPoint extends StatelessWidget {
  BulletPoint({this.bulletTitle, this.appProvider, this.mq});

  final String bulletTitle;
  final AppProvider appProvider;
  final MediaQueryData mq;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: ListTileMoreCustomizable(
        leading: Container(
          height: DeviceUtils.getResponsive(
              mq: mq, appProvider: appProvider, onPhone: 10.0, onTablet: 20.0),
          width: DeviceUtils.getResponsive(
              mq: mq, appProvider: appProvider, onPhone: 10.0, onTablet: 20.0),
          decoration: new BoxDecoration(
            color: Color(0xFF8AB84B),
            shape: BoxShape.circle,
          ),
        ),
        dense: true,
        minLeadingWidth: DeviceUtils.getResponsive(
            mq: mq, appProvider: appProvider, onPhone: 20.0, onTablet: 40.0),
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.all(5),
        title: Text(
          bulletTitle,
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
    );
  }
}
