import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';
import 'package:provider/provider.dart';

class LoadingModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final mq = MediaQuery.of(context);
    final double boxSize = DeviceUtils.getResponsive(
        appProvider: appProvider, mq: mq, onPhone: 80.0, onTablet: 160.0);
    final loadingSize = boxSize * 0.4;
    return Center(
      child: Container(
        width: boxSize,
        height: boxSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFF6ABFBC),
        ),
        child: Center(
          child: SizedBox(
            width: loadingSize,
            height: loadingSize,
            child: Theme(
              data: Theme.of(context).copyWith(
                accentColor: Color(0xFF8AB84B),
              ),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
