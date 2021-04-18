import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';
import 'package:forte_life/widgets/bullet_point.dart';
import 'package:forte_life/widgets/field_title.dart';
import 'package:forte_life/widgets/info_table.dart';
import 'package:forte_life/widgets/info_tablerow.dart';
import 'package:provider/provider.dart';

class InfoScreenEdu extends StatefulWidget {
  @override
  _InfoScreenEduState createState() => _InfoScreenEduState();
}

class _InfoScreenEduState extends State<InfoScreenEdu> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    Map<String, dynamic> lang = appProvider.lang;

    final mq = MediaQuery.of(context);

    List<InfoTableRow> tableChildren = [
      InfoTableRow(
          appProvider: appProvider,
          mq: mq,
          leadingString: lang['row_1_lead'],
          trailingString: lang['row_1_trial']),
      InfoTableRow(
          appProvider: appProvider,
          mq: mq,
          leadingString: lang['row_2_lead'],
          trailingString: lang['row_1_trial']),
    ];

    return SafeArea(
      child: SingleChildScrollView(
          child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: 20, vertical: mq.size.height / 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: mq.size.height / 36),
              child: FieldTitle(
                fontSize: DeviceUtils.getResponsive(
                    mq: mq,
                    appProvider: appProvider,
                    onPhone: 21.0,
                    onTablet: 42.0),
                fieldTitle: lang['for_life_assured'],
              ),
            ),
            SizedBox(
                height: DeviceUtils.getResponsive(
                    mq: mq,
                    appProvider: appProvider,
                    onPhone: 10.0,
                    onTablet: 20.0)),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF8AB84B)),
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.1), BlendMode.dstATop),
                      image: AssetImage("assets/icons/attention.png"))),
              child: Column(
                children: [
                  BulletPoint(
                    appProvider: appProvider,
                    mq: mq,
                    bulletTitle: lang['line_1_edu'],
                  ),
                  BulletPoint(
                    appProvider: appProvider,
                    mq: mq,
                    bulletTitle: lang['line_2_edu'],
                  ),
                ],
              ),
            ),
            SizedBox(
                height: DeviceUtils.getResponsive(
                    mq: mq,
                    appProvider: appProvider,
                    onPhone: 20.0,
                    onTablet: 40.0)),
            FieldTitle(
              fontSize: DeviceUtils.getResponsive(
                  mq: mq,
                  appProvider: appProvider,
                  onPhone: 21.0,
                  onTablet: 42.0),
              fieldTitle: lang['for_payor'],
            ),
            SizedBox(
                height: DeviceUtils.getResponsive(
                    mq: mq,
                    appProvider: appProvider,
                    onPhone: 10.0,
                    onTablet: 20.0)),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF8AB84B)),
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.1), BlendMode.dstATop),
                      image: AssetImage("assets/icons/attention.png"))),
              child: Column(
                children: [
                  BulletPoint(
                    appProvider: appProvider,
                    mq: mq,
                    bulletTitle: lang['line_3_edu'],
                  ),
                  BulletPoint(
                    appProvider: appProvider,
                    mq: mq,
                    bulletTitle: lang['line_3'],
                  )
                ],
              ),
            ),
            SizedBox(
                height: DeviceUtils.getResponsive(
                    mq: mq,
                    appProvider: appProvider,
                    onPhone: 20.0,
                    onTablet: 40.0)),
            FieldTitle(
              fontSize: DeviceUtils.getResponsive(
                  mq: mq,
                  appProvider: appProvider,
                  onPhone: 21.0,
                  onTablet: 42.0),
              fieldTitle: lang['benefits'],
            ),
            SizedBox(
                height: DeviceUtils.getResponsive(
                    mq: mq,
                    appProvider: appProvider,
                    onPhone: 15.0,
                    onTablet: 30.0)),
            Text(
              lang['for_life_assured'],
              style: TextStyle(
                  fontSize: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 18.0,
                      onTablet: 36.0),
                  fontFamily: "Kano",
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFD31145)),
            ),
            SizedBox(
                height: DeviceUtils.getResponsive(
                    mq: mq,
                    appProvider: appProvider,
                    onPhone: 10.0,
                    onTablet: 20.0)),
            InfoTable(
              tableChildren: tableChildren,
            ),
            SizedBox(
                height: DeviceUtils.getResponsive(
                    mq: mq,
                    appProvider: appProvider,
                    onPhone: 15.0,
                    onTablet: 30.0)),
            Text(
              lang['for_payor'],
              style: TextStyle(
                  fontSize: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 18.0,
                      onTablet: 36.0),
                  fontFamily: "Kano",
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFD31145)),
            ),
            SizedBox(
                height: DeviceUtils.getResponsive(
                    mq: mq,
                    appProvider: appProvider,
                    onPhone: 10.0,
                    onTablet: 20.0)),
            Text(
              lang['waive_edu'],
              style: TextStyle(
                  fontSize: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 15.0,
                      onTablet: 30.0),
                  fontFamily: "Kano",
                  color: Colors.black),
            ),
            SizedBox(
                height: DeviceUtils.getResponsive(
                    mq: mq,
                    appProvider: appProvider,
                    onPhone: 20.0,
                    onTablet: 40.0)),
            FieldTitle(
              fontSize: DeviceUtils.getResponsive(
                  mq: mq,
                  appProvider: appProvider,
                  onPhone: 21.0,
                  onTablet: 42.0),
              fieldTitle: lang['maturity_benefits'],
            ),
            SizedBox(
                height: DeviceUtils.getResponsive(
                    mq: mq,
                    appProvider: appProvider,
                    onPhone: 10.0,
                    onTablet: 20.0)),
            Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF6ABFBC).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    lang['maturity_benefits_details_edu'],
                    style: TextStyle(
                        color: Color(0xFF4D4D4D),
                        fontSize: DeviceUtils.getResponsive(
                            mq: mq,
                            appProvider: appProvider,
                            onPhone: 15.0,
                            onTablet: 30.0),
                        fontFamily: "Kano"),
                  ),
                )),
          ],
        ),
      )),
    );
  }
}
