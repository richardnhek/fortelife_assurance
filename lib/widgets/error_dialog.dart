import 'package:flutter/material.dart';
import 'package:forte_life/widgets/custom_alert_dialog.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    this.details,
    this.onActionButtonPressed,
  });

  final String details;
  final Function onActionButtonPressed;

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      icon: Image.asset("assets/icons/attention.png", width: 60, height: 60),
      title: "Error",
      details: details,
      isPrompt: false,
      actionButtonTitle: "OK",
      actionButtonTitleTwo: " ",
      onActionButtonPressed: onActionButtonPressed,
    );
  }
}
