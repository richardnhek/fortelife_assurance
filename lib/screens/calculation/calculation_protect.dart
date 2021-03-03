import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/widgets/custom_alert_dialog.dart';
import 'package:forte_life/widgets/tab_button.dart';
import 'calculation_protect_ui.dart';
import 'package:forte_life/screens/info/info_screen.dart';
import 'package:provider/provider.dart';

class CalculationProtect extends StatefulWidget {
  @override
  _CalculationProtectState createState() => _CalculationProtectState();
}

class _CalculationProtectState extends State<CalculationProtect> {
  final tabs = [CalculationProtectUI(), InfoScreen()];

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    final mq = MediaQuery.of(context);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    void _showExitDialog(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) => Center(
                child: CustomAlertDialog(
                  title: "Exit",
                  icon: Image.asset("assets/icons/attention.png",
                      width: 60, height: 60),
                  details: "Are you sure you want to leave this page?",
                  actionButtonTitle: "No",
                  actionButtonTitleTwo: "Yes",
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

    return WillPopScope(
        onWillPop: () async {
          _showExitDialog(_scaffoldKey.currentContext);
        },
        child: Scaffold(
          key: _scaffoldKey,
          body: Stack(children: [
            tabs[appProvider.calculationPage],
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
                        tabTitle: "Calculator",
                        width: mq.size.width / 2,
                        height: mq.size.height / 10,
                        icon: Icons.calculate_outlined,
                        isActive: appProvider.calculationPage == 0,
                        onPressed: () {
                          setState(() {
                            appProvider.calculationPage = 0;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: TabButton(
                        width: mq.size.width / 2,
                        height: mq.size.height / 10,
                        tabTitle: "Information",
                        icon: Icons.info_outline,
                        isActive: appProvider.calculationPage == 1,
                        onPressed: () {
                          setState(() {
                            appProvider.calculationPage = 1;
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
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightElevation: 0,
              heroTag: "backBtn",
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 32,
              ),
              onPressed: () {
                _showExitDialog(_scaffoldKey.currentContext);
              },
            ),
          ),
        ));
  }
}
