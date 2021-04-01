import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forte_life/screens/pdf/pdf_screen.dart';
import 'package:forte_life/widgets/custom_alert_dialog.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
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
                  title: lang['exit'],
                  icon: Image.asset("assets/icons/attention.png",
                      width: 60, height: 60),
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
                  title: lang['exit'],
                  icon: Image.asset("assets/icons/off.png",
                      width: 60, height: 60),
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
          height: 60.0,
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
                  height: 3.5,
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
                iconSize: 25.0,
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
