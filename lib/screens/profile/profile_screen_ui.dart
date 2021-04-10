import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forte_life/constants/constants.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';
import 'package:forte_life/widgets/custom_alert_dialog.dart';
import 'package:forte_life/widgets/customizable_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreenUI extends StatelessWidget {
  ProfileScreenUI(
      {this.onLogOut,
      this.onChangePassword,
      this.newPasswordController,
      this.confirmController});
  final Function onLogOut;
  final Function onChangePassword;
  final TextEditingController newPasswordController;
  final TextEditingController confirmController;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final appProvider = Provider.of<AppProvider>(context);
    final GlobalKey mainContainer = GlobalKey();
    Map<String, dynamic> lang = appProvider.lang;

    onSwitchLanguage(String languageCode) async {
      final prefs = await SharedPreferences.getInstance();
      AppProvider appProvider =
          Provider.of<AppProvider>(context, listen: false);
      print(languageCode);
      prefs.setString(APP_LANGUAGE, languageCode);
      appProvider.language = languageCode;
    }

    void _showSwitchLanguageDialog() {
      showDialog(
          context: context,
          builder: (ctx) => Center(
                child: CustomizableAlertDialog(
                  appProvider: appProvider,
                  mq: mq,
                  title: lang['app_language'],
                  icon: Icon(
                    Icons.language,
                    size: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 60.0,
                        onTablet: 120.0),
                    color: Color(0xFF8AB84B),
                  ),
                  firstWidget: Image(
                    image: AssetImage("assets/icons/khmer.png"),
                    width: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 70.0,
                        onTablet: 140.0),
                    height: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 45.0,
                        onTablet: 90.0),
                    fit: BoxFit.cover,
                  ),
                  firstHeight: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 45.0,
                      onTablet: 90.0),
                  secondWidget: Image(
                    image: AssetImage("assets/icons/english.png"),
                    width: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 70.0,
                        onTablet: 140.0),
                    height: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 45.0,
                        onTablet: 90.0),
                    fit: BoxFit.cover,
                  ),
                  secondHeight: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 45.0,
                      onTablet: 90.0),
                  details: lang['applanguage_text'],
                  onActionButtonPressed: () {
                    onSwitchLanguage(LANGUAGE_KHMER);
                    Navigator.of(context).pop();
                  },
                  onActionButtonPressedTwo: () {
                    onSwitchLanguage(LANGUAGE_ENGLISH);
                    Navigator.of(context).pop();
                  },
                ),
              ));
    }

    void _showExitDialog() {
      showDialog(
          context: context,
          builder: (ctx) => Center(
                child: CustomAlertDialog(
                  appProvider: appProvider,
                  mq: mq,
                  title: lang['log_out'],
                  icon: Icon(
                    Icons.logout,
                    size: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 60.0,
                        onTablet: 120.0),
                    color: Color(0xFFD31145),
                  ),
                  details: lang['logout_text'],
                  actionButtonTitle: lang['no'],
                  actionButtonTitleTwo: lang['yes'],
                  isPrompt: true,
                  onActionButtonPressed: () {
                    Navigator.of(context).pop();
                  },
                  onActionButtonPressedTwo: () {
                    Navigator.of(context).pop();
                    onLogOut();
                  },
                ),
              ));
    }

    void _showChangePassword() {
      showDialog(
          context: context,
          builder: (ctx) => Material(
              type: MaterialType.transparency,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: DeviceUtils.getResponsive(
                          mq: mq,
                          appProvider: appProvider,
                          onPhone: 400.0,
                          onTablet: 800.0),
                      minHeight: 300,
                      minWidth: 250,
                      maxWidth: DeviceUtils.getResponsive(
                          mq: mq,
                          appProvider: appProvider,
                          onPhone: 300.0,
                          onTablet: 600.0)),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.lock_outline_rounded,
                              size: DeviceUtils.getResponsive(
                                  mq: mq,
                                  appProvider: appProvider,
                                  onPhone: 60.0,
                                  onTablet: 120.0),
                              color: Color(0xFFD31145),
                            )),
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
                                onPhone: 180.0,
                                onTablet: 360.0),
                            child: Text(
                              lang['change_pass'],
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
                                onPhone: 20.0,
                                onTablet: 40.0)),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                lang['new_pass'] + ": ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: DeviceUtils.getResponsive(
                                        mq: mq,
                                        appProvider: appProvider,
                                        onPhone: 14.0,
                                        onTablet: 28.0),
                                    fontFamily: "Kano"),
                              ),
                              SizedBox(
                                  width: DeviceUtils.getResponsive(
                                      mq: mq,
                                      appProvider: appProvider,
                                      onPhone: appProvider.language == "kh"
                                          ? 11.0
                                          : 5.0,
                                      onTablet: appProvider.language == "kh"
                                          ? 22.0
                                          : 10.0)),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: DeviceUtils.getResponsive(
                                          mq: mq,
                                          appProvider: appProvider,
                                          onPhone: 21.0,
                                          onTablet: 42.0)),
                                  width: double.infinity,
                                  height: DeviceUtils.getResponsive(
                                      mq: mq,
                                      appProvider: appProvider,
                                      onPhone: 50.0,
                                      onTablet: 100.0),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xFFB8B8B8))),
                                  child: TextFormField(
                                    controller: newPasswordController,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                        disabledBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(left: 5, top: 15),
                                        isDense: true,
                                        hintText: lang['new_pass'],
                                        hintStyle: TextStyle(
                                            fontFamily: "Kano",
                                            fontSize: DeviceUtils.getResponsive(
                                                mq: mq,
                                                appProvider: appProvider,
                                                onPhone: 15.0,
                                                onTablet: 30.0),
                                            color:
                                                Colors.black.withOpacity(0.5))),
                                    style: TextStyle(
                                        fontFamily: "Kano",
                                        fontSize: DeviceUtils.getResponsive(
                                            mq: mq,
                                            appProvider: appProvider,
                                            onPhone: 14.0,
                                            onTablet: 28.0),
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ]),
                        SizedBox(
                            height: DeviceUtils.getResponsive(
                                mq: mq,
                                appProvider: appProvider,
                                onPhone: 10.0,
                                onTablet: 20.0)),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                lang['confirm_pass'] + ": ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: DeviceUtils.getResponsive(
                                        mq: mq,
                                        appProvider: appProvider,
                                        onPhone: 14.0,
                                        onTablet: 28.0),
                                    fontFamily: "Kano"),
                              ),
                              SizedBox(
                                  width: DeviceUtils.getResponsive(
                                      mq: mq,
                                      appProvider: appProvider,
                                      onPhone: 5.0,
                                      onTablet: 10.0)),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  height: DeviceUtils.getResponsive(
                                      mq: mq,
                                      appProvider: appProvider,
                                      onPhone: 50.0,
                                      onTablet: 100.0),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xFFB8B8B8))),
                                  child: TextFormField(
                                    controller: confirmController,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                        disabledBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(left: 5, top: 15),
                                        isDense: true,
                                        hintText: lang['confirm_pass'],
                                        hintStyle: TextStyle(
                                            fontFamily: "Kano",
                                            fontSize: DeviceUtils.getResponsive(
                                                mq: mq,
                                                appProvider: appProvider,
                                                onPhone: 15.0,
                                                onTablet: 30.0),
                                            color:
                                                Colors.black.withOpacity(0.5))),
                                    style: TextStyle(
                                        fontFamily: "Kano",
                                        fontSize: DeviceUtils.getResponsive(
                                            mq: mq,
                                            appProvider: appProvider,
                                            onPhone: 14.0,
                                            onTablet: 28.0),
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ]),
                        SizedBox(
                            height: DeviceUtils.getResponsive(
                                mq: mq,
                                appProvider: appProvider,
                                onPhone: 20.0,
                                onTablet: 40.0)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 50.0,
                                    onTablet: 100.0),
                                width: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 100.0,
                                    onTablet: 200.0),
                                child: FlatButton(
                                  color: Color(0xFFD31145),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    lang['cancel'],
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
                                    onPhone: 100.0,
                                    onTablet: 200.0),
                                child: FlatButton(
                                  color: Color(0xFF8AB84B),
                                  onPressed: () => onChangePassword(context),
                                  child: Text(
                                    lang['confirm'],
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
                      ],
                    ),
                  ),
                ),
              )));
    }

    void _showContactDialog() {
      showDialog(
          context: context,
          builder: (ctx) => Material(
                type: MaterialType.transparency,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: DeviceUtils.getResponsive(
                            mq: mq,
                            appProvider: appProvider,
                            onPhone: 300.0,
                            onTablet: 600.0),
                        minHeight: 250,
                        minWidth: 250,
                        maxWidth: DeviceUtils.getResponsive(
                            mq: mq,
                            appProvider: appProvider,
                            onPhone: 300.0,
                            onTablet: 600.0)),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                image: new AssetImage(
                                    "assets/pictures/android/logo/logo.png"),
                                fit: BoxFit.contain,
                              ),
                            ),
                            height: DeviceUtils.getResponsive(
                                mq: mq,
                                appProvider: appProvider,
                                onPhone: 40.0,
                                onTablet: 80.0),
                            width: DeviceUtils.getResponsive(
                                mq: mq,
                                appProvider: appProvider,
                                onPhone: 125.0,
                                onTablet: 250.0),
                          ),
                          Text(
                            lang['about'],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 15.0,
                                    onTablet: 30.0),
                                fontFamily: "Kano"),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lang['phone'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: DeviceUtils.getResponsive(
                                          mq: mq,
                                          appProvider: appProvider,
                                          onPhone: 18.0,
                                          onTablet: 36.0),
                                      fontFamily: "Kano"),
                                ),
                                Text(
                                  "(+855) 23 885 077 / 066",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: DeviceUtils.getResponsive(
                                          mq: mq,
                                          appProvider: appProvider,
                                          onPhone: 12.5,
                                          onTablet: 25.0),
                                      fontFamily: "Kano"),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lang['fax'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: DeviceUtils.getResponsive(
                                          mq: mq,
                                          appProvider: appProvider,
                                          onPhone: 18.0,
                                          onTablet: 36.0),
                                      fontFamily: "Kano"),
                                ),
                                Text(
                                  "(+855) 23 986 922",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: DeviceUtils.getResponsive(
                                          mq: mq,
                                          appProvider: appProvider,
                                          onPhone: 12.5,
                                          onTablet: 25.0),
                                      fontFamily: "Kano"),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lang['email'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: DeviceUtils.getResponsive(
                                          mq: mq,
                                          appProvider: appProvider,
                                          onPhone: 18.0,
                                          onTablet: 36.0),
                                      fontFamily: "Kano"),
                                ),
                                Text(
                                  "info@fortelifeassurance.com",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: DeviceUtils.getResponsive(
                                          mq: mq,
                                          appProvider: appProvider,
                                          onPhone: 12.5,
                                          onTablet: 25.0),
                                      fontFamily: "Kano"),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: DeviceUtils.getResponsive(
                                  mq: mq,
                                  appProvider: appProvider,
                                  onPhone: 15.0,
                                  onTablet: 30.0)),
                          FlatButton(
                            splashColor: Colors.blueAccent.withOpacity(0.16),
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontSize: DeviceUtils.getResponsive(
                                      mq: mq,
                                      appProvider: appProvider,
                                      onPhone: 16.0,
                                      onTablet: 32.0),
                                  color: Colors.blueAccent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
    }

    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        height: mq.size.height,
        child: Stack(alignment: Alignment.center, children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: new BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF92C04A), Color(0xFF6ABFBC)])),
              height: DeviceUtils.getResponsive(
                  mq: mq,
                  appProvider: appProvider,
                  onPhone: 400.0,
                  onTablet: 600.0),
              width: mq.size.width,
            ),
          ),
          Align(
            child: Container(
              key: mainContainer,
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.only(
                  top: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 15.0,
                      onTablet: 30.0)),
              width: DeviceUtils.getResponsive(
                  mq: mq,
                  appProvider: appProvider,
                  onPhone: 300.0,
                  onTablet: 600.0),
              height: DeviceUtils.getResponsive(
                  mq: mq,
                  appProvider: appProvider,
                  onPhone: 320.0,
                  onTablet: 640.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.5),
                  color: Color(0xFFFFFFFF),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        blurRadius: 15,
                        spreadRadius: 1,
                        offset: Offset(3, 6)),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Username: ${appProvider.userName}",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: DeviceUtils.getResponsive(
                            mq: mq,
                            appProvider: appProvider,
                            onPhone: 15.0,
                            onTablet: 30.0),
                        fontFamily: "Kano"),
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _showSwitchLanguageDialog,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            lang['language'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 18.0,
                                    onTablet: 36.0),
                                fontFamily: "Kano"),
                          ),
                          Icon(Icons.language,
                              color: Color(0xFF92C04A),
                              size: DeviceUtils.getResponsive(
                                  mq: mq,
                                  appProvider: appProvider,
                                  onPhone: 21.0,
                                  onTablet: 42.0))
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _showChangePassword,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            lang['change_pass'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 18.0,
                                    onTablet: 36.0),
                                fontFamily: "Kano"),
                          ),
                          Icon(
                            Icons.lock_outline,
                            color: Color(0xFF92C04A),
                            size: DeviceUtils.getResponsive(
                                mq: mq,
                                appProvider: appProvider,
                                onPhone: 21.0,
                                onTablet: 42.0),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _showContactDialog,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            lang['contact_us'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 18.0,
                                    onTablet: 36.0),
                                fontFamily: "Kano"),
                          ),
                          Icon(Icons.contact_page_outlined,
                              color: Color(0xFF92C04A),
                              size: DeviceUtils.getResponsive(
                                  mq: mq,
                                  appProvider: appProvider,
                                  onPhone: 21.0,
                                  onTablet: 42.0))
                        ],
                      ),
                    ),
                  ),
                  RaisedButton(
                      onPressed: _showExitDialog,
                      padding: EdgeInsets.all(
                          appProvider.language == "kh" ? 10 : 15),
                      disabledColor: Color(0xFFD31145),
                      color: Color(0xFFD31145),
                      disabledElevation: 2.5,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            lang['log_out'],
                            style: TextStyle(
                                fontSize: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 17.5,
                                    onTablet: 35.0),
                                color: Colors.white,
                                fontFamily: "Kano",
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.logout,
                            size: DeviceUtils.getResponsive(
                                mq: mq,
                                appProvider: appProvider,
                                onPhone: 21.0,
                                onTablet: 42.0),
                            color: Colors.white,
                          )
                        ],
                      ))
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
