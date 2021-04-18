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
      return onTablet;
    }
    return onPhone;
  }
}
