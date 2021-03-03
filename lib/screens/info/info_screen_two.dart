import 'package:flutter/material.dart';
import 'package:forte_life/widgets/bullet_point.dart';
import 'package:forte_life/widgets/field_title.dart';
import 'package:forte_life/widgets/info_table.dart';
import 'package:forte_life/widgets/info_tablerow.dart';

class InfoScreenEdu extends StatefulWidget {
  @override
  _InfoScreenEduState createState() => _InfoScreenEduState();
}

class _InfoScreenEduState extends State<InfoScreenEdu> {
  List<InfoTableRow> tableChildren = [
    InfoTableRow(
        leadingString: "Death due to all causes benefits:",
        trailingString: "100% of Sum Assured"),
    InfoTableRow(
        leadingString: "TPD due to all causes benefit:",
        trailingString: "100% of Sum Assured"),
  ];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
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
                fieldTitle: "For Life Assured (Child)",
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
                    bulletTitle: "Term From:  10 Years \nTo:  17 Years",
                  ),
                  BulletPoint(
                    bulletTitle:
                        "Entry Age From:  1 Years Old \nTo:  8 Years Old",
                  ),
                  BulletPoint(
                    bulletTitle: "Maximum Maturity Age:\n69 Years Old",
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            FieldTitle(
              fieldTitle: "For Payor (Parent)",
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
                    bulletTitle:
                        "Entry Age From:  18 Years Old \nTo:  59 Years Old",
                  ),
                  BulletPoint(
                    bulletTitle: "Maximum Maturity Age:\n69 Years Old",
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            FieldTitle(
              fieldTitle: "Benefits",
            ),
            SizedBox(height: 15),
            Text(
              "For Life Assured (Child)",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Kano",
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFD31145)),
            ),
            SizedBox(height: 10),
            InfoTable(
              tableChildren: tableChildren,
            ),
            SizedBox(height: 15),
            Text(
              "For Payor (Parent)",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Kano",
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFD31145)),
            ),
            SizedBox(height: 10),
            Text(
              "Waive premium due to Death/TPD of Payor",
              style: TextStyle(
                  fontSize: 15, fontFamily: "Kano", color: Colors.black),
            ),
            SizedBox(height: 20),
            FieldTitle(
              fieldTitle: "Maturity Benefits",
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
                    "Sum Assured + 2% of Sum Assured x Term\nIf Entry Age below 50\n\nSum Assured + 1% of Sum assured x Term\nIf entry age 50 or above",
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
