import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';

import 'package:forte_life/widgets/username_field.dart';
import 'package:forte_life/widgets/password_field.dart';
import 'package:provider/provider.dart';

class LoginScreenUI extends StatelessWidget {
  LoginScreenUI(
      {this.usernameController,
      this.passwordController,
      this.onSignInPress,
      this.scaffoldKey});

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final Function onSignInPress;
  final scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    AppProvider appProvider = Provider.of<AppProvider>(context);
    Map<String, dynamic> lang = appProvider.lang;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
                fit: BoxFit.fill,
                image: AssetImage("assets/pictures/android/gradient1.png"),
                gaplessPlayback: true),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: DeviceUtils.getResponsive(
                    mq: mq,
                    appProvider: appProvider,
                    onPhone: mq.size.width / 8,
                    onTablet: mq.size.width / 4)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  width: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 300.0,
                      onTablet: 600.0),
                  height: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 52.0,
                      onTablet: 150.0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/pictures/android/logo/logo.png"),
                          fit: BoxFit.contain)),
                ),
                SizedBox(height: 50),
                UserNameField(
                  fieldHeight: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 50.0,
                      onTablet: 75.0),
                  fieldWidth: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 300.0,
                      onTablet: 600.0),
                  iconSize: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 16.0,
                      onTablet: 32.0),
                  fontSize: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 14.0,
                      onTablet: 24.0),
                  extraPad: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 2.0,
                      onTablet: 4.0),
                  ctnPadding: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 15.0,
                      onTablet: 20.0),
                  hintText: lang['username'],
                  tec: usernameController,
                ),
                SizedBox(
                  height: 15,
                ),
                PasswordField(
                  fieldHeight: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 50.0,
                      onTablet: 75.0),
                  fieldWidth: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 300.0,
                      onTablet: 600.0),
                  iconSize: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 16.0,
                      onTablet: 32.0),
                  fontSize: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 14.0,
                      onTablet: 24.0),
                  extraPad: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 2.0,
                      onTablet: 4.0),
                  ctnPadding: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 15.0,
                      onTablet: 20.0),
                  hintText: lang['password'],
                  tec: passwordController,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 100.0,
                      onTablet: 200.0),
                  height: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 50.0,
                      onTablet: 100.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF6ABFBC), Color(0xFF8AB84B)])),
                  child: RaisedButton(
                    padding: EdgeInsets.all(10),
                    elevation: 2.5,
                    disabledElevation: 2.5,
                    disabledColor: Color(0xFF8AB84B),
                    color: Color(0xFF8AB84B),
                    onPressed: () => onSignInPress(context),
                    child: Text(
                      lang['login'],
                      style: TextStyle(
                          fontSize: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 17.5,
                              onTablet: 30.0),
                          fontFamily: "Kano",
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Image(
                width: double.infinity,
                fit: BoxFit.fill,
                image: AssetImage("assets/pictures/android/gradient2.png"),
                gaplessPlayback: true),
          ),
        ],
      ),
    );
  }
}
