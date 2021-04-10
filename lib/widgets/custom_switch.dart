import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';

class CustomSwitch extends StatelessWidget {
  CustomSwitch(
      {this.value, this.title, this.onChanged, this.appProvider, this.mq});

  final bool value;
  final Function onChanged;
  final String title;
  final AppProvider appProvider;
  final MediaQueryData mq;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SwitchListTile(
          title: Text(
            title,
            style: TextStyle(
                fontFamily: "Kano",
                fontSize: DeviceUtils.getResponsive(
                    mq: mq,
                    appProvider: appProvider,
                    onPhone: 15.0,
                    onTablet: 30.0),
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
