import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';
import 'package:forte_life/widgets/custom_alert_dialog.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog(
      {this.details, this.onActionButtonPressed, this.appProvider, this.mq});

  final String details;
  final Function onActionButtonPressed;
  final AppProvider appProvider;
  final MediaQueryData mq;

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      appProvider: appProvider,
      mq: mq,
      icon: Image.asset("assets/icons/attention.png",
          width: DeviceUtils.getResponsive(
              mq: mq, appProvider: appProvider, onPhone: 60.0, onTablet: 120.0),
          height: DeviceUtils.getResponsive(
              mq: mq,
              appProvider: appProvider,
              onPhone: 60.0,
              onTablet: 120.0)),
      title: "Error",
      details: details,
      isPrompt: false,
      actionButtonTitle: "OK",
      actionButtonTitleTwo: " ",
      onActionButtonPressed: onActionButtonPressed,
    );
  }
}
