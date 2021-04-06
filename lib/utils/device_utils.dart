import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';

class DeviceUtils {
  static dynamic getResponsive({
    AppProvider appProvider,
    MediaQueryData mq,
    dynamic onPhone,
    dynamic onTablet,
  }) {
    if (appProvider.isTablet) {
      print("On Tablet");
      return onTablet;
    }
    return onPhone;
  }
}
