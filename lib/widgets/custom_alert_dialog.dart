import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {this.icon,
      this.title,
      this.details,
      this.actionButtonTitle,
      this.actionButtonTitleTwo,
      this.onActionButtonPressed,
      this.onActionButtonPressedTwo,
      this.isPrompt,
      this.appProvider,
      this.mq});

  final Widget icon;
  final String title;
  final String details;
  final String actionButtonTitle;
  final String actionButtonTitleTwo;
  final Function onActionButtonPressed;
  final Function onActionButtonPressedTwo;
  final bool isPrompt;
  final AppProvider appProvider;
  final MediaQueryData mq;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: DeviceUtils.getResponsive(
              mq: mq,
              appProvider: appProvider,
              onPhone: 300.0,
              onTablet: 600.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              icon == null
                  ? Material()
                  : Align(
                      child: icon,
                      alignment: Alignment.center,
                    ),
              SizedBox(
                  height: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 20.0,
                      onTablet: 40.0)),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 150.0,
                      onTablet: 300.0),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Color(0xFFD31145),
                        fontSize: DeviceUtils.getResponsive(
                            mq: mq,
                            appProvider: appProvider,
                            onPhone: 22.0,
                            onTablet: 44.0),
                        fontFamily: "Kano",
                        fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                  height: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 10.0,
                      onTablet: 20.0)),
              Text(
                details,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Kano",
                    fontSize: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 15.0,
                        onTablet: 30.0)),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                  height: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 20.0,
                      onTablet: 40.0)),
              Visibility(
                visible: isPrompt,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    height: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 50.0,
                        onTablet: 100.0),
                    width: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 115.0,
                        onTablet: 230.0),
                    child: FlatButton(
                      color: Color(0xFF8AB84B),
                      onPressed: onActionButtonPressed,
                      child: Text(
                        actionButtonTitle,
                        style: TextStyle(
                            fontSize: DeviceUtils.getResponsive(
                                mq: mq,
                                appProvider: appProvider,
                                onPhone: 16.0,
                                onTablet: 32.0),
                            fontFamily: "Kano",
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: DeviceUtils.getResponsive(
                          mq: mq,
                          appProvider: appProvider,
                          onPhone: 10.0,
                          onTablet: 20.0)),
                  SizedBox(
                    height: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 50.0,
                        onTablet: 100.0),
                    width: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 115.0,
                        onTablet: 230.0),
                    child: FlatButton(
                      color: Color(0xFFD31145),
                      onPressed: onActionButtonPressedTwo,
                      child: Text(
                        actionButtonTitleTwo,
                        style: TextStyle(
                            fontSize: DeviceUtils.getResponsive(
                                mq: mq,
                                appProvider: appProvider,
                                onPhone: 16.0,
                                onTablet: 32.0),
                            fontFamily: "Kano",
                            color: Colors.white),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
