import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';
import 'package:forte_life/widgets/bullet_point.dart';
import 'package:forte_life/widgets/field_title.dart';
import 'package:forte_life/widgets/info_table.dart';
import 'package:forte_life/widgets/info_tablerow.dart';
import 'package:provider/provider.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    AppProvider appProvider = Provider.of<AppProvider>(context);
    Map<String, dynamic> lang = appProvider.lang;
    List<InfoTableRow> tableChildren = [
      InfoTableRow(
          leadingString: lang['row_1_lead'],
          trailingString: lang['row_1_trial']),
      InfoTableRow(
        leadingString: lang['row_2_lead'],
        trailingString: lang['row_1_trial'],
      ),
      InfoTableRow(
        leadingString: lang['row_3_lead'],
        trailingString: lang['row_3_trial'],
      ),
      InfoTableRow(
          leadingString: lang['row_4_lead'],
          trailingString: lang['row_3_trial']),
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
                fieldTitle: lang['for_life_proposed'],
              ),
            ),
            SizedBox(height: 10),
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
                    bulletTitle: lang['line_1'],
                  ),
                  BulletPoint(
                    bulletTitle: lang['line_2'],
                  ),
                  BulletPoint(
                    bulletTitle: lang['line_3'],
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            FieldTitle(
              fontSize: DeviceUtils.getResponsive(
                  mq: mq,
                  appProvider: appProvider,
                  onPhone: 21.0,
                  onTablet: 42.0),
              fieldTitle: lang['benefits'],
            ),
            SizedBox(height: 10),
            InfoTable(
              tableChildren: tableChildren,
            ),
            SizedBox(height: 20),
            FieldTitle(
              fontSize: DeviceUtils.getResponsive(
                  mq: mq,
                  appProvider: appProvider,
                  onPhone: 21.0,
                  onTablet: 42.0),
              fieldTitle: lang['maturity_benefits'],
            ),
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF6ABFBC).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    lang['maturity_benefits_details'],
                    style: TextStyle(
                        color: Color(0xFF4D4D4D),
                        fontSize: 15,
                        fontFamily: "Kano"),
                  ),
                )),
          ],
        ),
      )),
    );
  }
}
