import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/screens/calculation/calculation_education_ui.dart';
import 'package:forte_life/screens/info/info_screen_two.dart';
import 'package:forte_life/utils/device_utils.dart';
import 'package:forte_life/widgets/custom_alert_dialog.dart';
import 'package:forte_life/widgets/tab_button.dart';

import 'package:provider/provider.dart';

class CalculationEducation extends StatefulWidget {
  @override
  _CalculationEducationState createState() => _CalculationEducationState();
}

class _CalculationEducationState extends State<CalculationEducation> {
  final tabs = [CalculationEducationUI(), InfoScreenEdu()];

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    Map<String, dynamic> lang = appProvider.lang;
    final mq = MediaQuery.of(context);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
                  isPrompt: true,
                  actionButtonTitle: lang['no'],
                  actionButtonTitleTwo: lang['yes'],
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

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(children: [
        tabs[appProvider.calculationPageEdu],
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: mq.size.height / 7,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.16),
                spreadRadius: 1,
                blurRadius: 5)
          ]),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: TabButton(
                    tabTitle: lang['calculator_screen'],
                    width: mq.size.width / 2,
                    height: mq.size.height / 8,
                    fontSize: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 18.0,
                        onTablet: 32.0),
                    iconSize: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 28.0,
                        onTablet: 48.0),
                    icon: Icons.calculate_outlined,
                    isActive: appProvider.calculationPageEdu == 0,
                    onPressed: () {
                      setState(() {
                        appProvider.calculationPageEdu = 0;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: TabButton(
                    width: mq.size.width / 2,
                    height: mq.size.height / 8,
                    tabTitle: lang['info_screen'],
                    icon: Icons.info_outline,
                    fontSize: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 18.0,
                        onTablet: 32.0),
                    iconSize: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 28.0,
                        onTablet: 48.0),
                    isActive: appProvider.calculationPageEdu == 1,
                    onPressed: () {
                      setState(() {
                        appProvider.calculationPageEdu = 1;
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        )
      ]),
      floatingActionButton: AlignPositioned(
        alignment: Alignment.topLeft,
        dy: mq.size.height / 13.5,
        dx: mq.size.width / 20,
        child: FloatingActionButton(
          heroTag: "backBtn",
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: DeviceUtils.getResponsive(
                mq: mq,
                appProvider: appProvider,
                onPhone: 32.0,
                onTablet: 64.0),
          ),
          onPressed: () {
            _showExitDialog(_scaffoldKey.currentContext);
          },
        ),
      ),
    );
  }
}
