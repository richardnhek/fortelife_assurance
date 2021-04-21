import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';
import 'package:forte_life/widgets/calculator_button.dart';
import 'package:forte_life/widgets/field_title.dart';
import 'package:provider/provider.dart';

class HomeScreenUI extends StatefulWidget {
  @override
  _HomeScreenUIState createState() => _HomeScreenUIState();
}

class _HomeScreenUIState extends State<HomeScreenUI> {
  Image topGradient;
  @override
  void initState() {
    super.initState();
    topGradient = Image.asset("assets/pictures/android/gradient3_test.png");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(topGradient.image, context, size: Size.infinite);
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    Map<String, dynamic> lang = appProvider.lang;

    final mq = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Stack(
        children: [
          Image(image: topGradient.image, gaplessPlayback: true),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: mq.size.height / 8,
                    left: DeviceUtils.getResponsive(
                        appProvider: appProvider,
                        mq: mq,
                        onPhone: 25.0,
                        onTablet: 50.0)),
                child: Container(
                  width: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 200.0,
                      onTablet: 400.0),
                  height: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 50.0,
                      onTablet: 100.0),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/pictures/android/logo/logo.png"),
                          fit: BoxFit.contain)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: mq.size.height / 6,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: DeviceUtils.getResponsive(
                          mq: mq,
                          appProvider: appProvider,
                          onPhone: 15.0,
                          onTablet: 50.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: FieldTitle(
                          fontSize: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 24.0,
                              onTablet: 48.0),
                          fieldTitle: lang['forte_title'],
                        ),
                      ),
                      SizedBox(
                          height: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 25.0,
                              onTablet: 50.0)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CalculatorButton(
                                fontSize: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 12.75,
                                    onTablet: 28.0),
                                btnSize: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 140.0,
                                    onTablet: 280.0),
                                imgSize: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 60.0,
                                    onTablet: 120.0),
                                calculatorTitle: lang['forte_protect'],
                                calculatorDesc: lang['insurance_plan'],
                                calculatorOnTap: () =>
                                    {appProvider.categoriesTabIndex = 1},
                                calculatorImg:
                                    AssetImage("assets/icons/shield.png"),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: CalculatorButton(
                                fontSize: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 12.75,
                                    onTablet: 28.0),
                                btnSize: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 140.0,
                                    onTablet: 280.0),
                                imgSize: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 60.0,
                                    onTablet: 120.0),
                                calculatorTitle: lang['forte_edu'],
                                calculatorDesc: lang['insurance_plan'],
                                calculatorOnTap: () =>
                                    {appProvider.categoriesTabIndex = 2},
                                calculatorImg:
                                    AssetImage("assets/icons/gradhat.png"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: DeviceUtils.getResponsive(
                            mq: mq,
                            appProvider: appProvider,
                            onPhone: 50.0,
                            onTablet: 75.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: FieldTitle(
                          fontSize: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 24.0,
                              onTablet: 48.0),
                          fieldTitle: lang['forte_videos'],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: mq.size.height / 15),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            "Coming Soon",
                            style: TextStyle(
                                color: Colors.grey.withOpacity(0.5),
                                fontSize: 15,
                                fontFamily: "Kano"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
