import 'dart:async';
import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forte_life/screens/pdf/pdf_screen.dart';
import 'package:forte_life/utils/device_utils.dart';
import 'package:forte_life/widgets/custom_alert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/constants.dart';
import 'screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/profile/profile_screen.dart';

class MainFlow extends StatefulWidget {
  @override
  _MainFlowState createState() => _MainFlowState();
}

class _MainFlowState extends State<MainFlow> {
  final tabs = [HomeScreen(), PDFScreen(), ProfileScreen()];
  StreamSubscription<DataConnectionStatus> listener;

  @override
  void initState() {
    super.initState();
    reLoginPrompt();
  }

  void reLoginPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(OFFLINE_DATE)) {
      final offlineDateString = prefs.getString(OFFLINE_DATE);
      final offlineDate = DateTime.parse(offlineDateString);
      final currentDate = DateTime.now();
      final offlineDuration = currentDate.difference(offlineDate).inHours;
      if (offlineDuration >= 24) {
        prefs.setString("OFFLINE_STATUS", OFFLINE_STATUS);
        prefs.remove(APP_ACCESS_TOKEN);
      }
    }

    if (prefs.containsKey("OFFLINE_STATUS")) {
      AppProvider appProvider =
          Provider.of<AppProvider>(context, listen: false);
      final mq = MediaQuery.of(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  },
                  child: CustomAlertDialog(
                    appProvider: appProvider,
                    title: "Exit",
                    icon: Image.asset("assets/icons/off.png",
                        width: DeviceUtils.getResponsive(
                            mq: mq,
                            appProvider: appProvider,
                            onPhone: 60.0,
                            onTablet: 120.0),
                        height: DeviceUtils.getResponsive(
                            mq: mq,
                            appProvider: appProvider,
                            onPhone: 60.0,
                            onTablet: 120.0)),
                    details:
                        "You've Been Offline For 24 Hours Please Log In Again",
                    actionButtonTitle: "No",
                    actionButtonTitleTwo: "Yes",
                    isPrompt: false,
                  ),
                ),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    final mq = MediaQuery.of(context);
    Map<String, dynamic> lang = appProvider.lang;
    void onTappedBar(int index) {
      if (appProvider.activeTabIndex == 0) {
        appProvider.categoriesTabIndex = 0;
      }
      setState(() {
        appProvider.activeTabIndex = index;
      });
    }

    void _showExitDialog(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) => Center(
                child: CustomAlertDialog(
                  appProvider: appProvider,
                  mq: mq,
                  title: lang['exit'],
                  icon: Image.asset("assets/icons/attention.png",
                      width: DeviceUtils.getResponsive(
                          mq: mq,
                          appProvider: appProvider,
                          onPhone: 60.0,
                          onTablet: 120.0),
                      height: DeviceUtils.getResponsive(
                          mq: mq,
                          appProvider: appProvider,
                          onPhone: 60.0,
                          onTablet: 120.0)),
                  details: lang['exit_page'],
                  actionButtonTitle: lang['no'],
                  actionButtonTitleTwo: lang['yes'],
                  isPrompt: true,
                  onActionButtonPressed: () {
                    Navigator.of(context).pop();
                  },
                  onActionButtonPressedTwo: () {
                    Navigator.of(context).pop();
                    appProvider.categoriesTabIndex = 0;
                  },
                ),
              ));
    }

    void _showLeaveDialog(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) => Center(
                child: CustomAlertDialog(
                  appProvider: appProvider,
                  mq: mq,
                  title: lang['exit'],
                  icon: Image.asset("assets/icons/off.png",
                      width: DeviceUtils.getResponsive(
                          mq: mq,
                          appProvider: appProvider,
                          onPhone: 60.0,
                          onTablet: 120.0),
                      height: DeviceUtils.getResponsive(
                          mq: mq,
                          appProvider: appProvider,
                          onPhone: 60.0,
                          onTablet: 120.0)),
                  details: lang['exit_app'],
                  actionButtonTitle: lang['no'],
                  actionButtonTitleTwo: lang['yes'],
                  isPrompt: true,
                  onActionButtonPressed: () {
                    Navigator.of(context).pop();
                  },
                  onActionButtonPressedTwo: () {
                    Navigator.of(context).pop();
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                ),
              ));
    }

    return WillPopScope(
      onWillPop: () async {
        if (appProvider.activeTabIndex != 0) {
          appProvider.activeTabIndex = 0;
          return true;
        } else {
          if (appProvider.categoriesTabIndex != 0) {
            _showExitDialog(context);
          } else
            _showLeaveDialog(context);
        }
        return false;
      },
      child: Scaffold(
        body: IndexedStack(
          index: appProvider.activeTabIndex,
          children: tabs,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.16),
                    spreadRadius: 1.0,
                    blurRadius: 15.0)
              ],
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF92C04A), Color(0xFF6ABFBC)])),
          height: DeviceUtils.getResponsive(
              mq: mq,
              appProvider: appProvider,
              onPhone: Platform.isIOS ? 85.0 : 60.0,
              onTablet: 120.0),
          width: double.infinity,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            final tabWidth = constraints.maxWidth / 3;
            return Stack(children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOutQuad,
                left: tabWidth * appProvider.activeTabIndex,
                bottom: 0,
                child: Container(
                  height: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 3.5,
                      onTablet: 7.0),
                  width: tabWidth,
                  color: Colors.white,
                ),
              ),
              BottomNavigationBar(
                backgroundColor: Colors.transparent,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: false,
                onTap: onTappedBar,
                elevation: 0,
                currentIndex: appProvider.activeTabIndex,
                showSelectedLabels: false,
                unselectedItemColor: Colors.white,
                selectedItemColor: Colors.white,
                iconSize: DeviceUtils.getResponsive(
                    mq: mq,
                    appProvider: appProvider,
                    onPhone: Platform.isIOS ? 25.0 : 25.0,
                    onTablet: 50.0),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.article_outlined),
                    label: 'Information',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline_rounded),
                    label: "Profile",
                  ),
                ],
              ),
            ]);
          }),
        ),
      ),
    );
  }
}
