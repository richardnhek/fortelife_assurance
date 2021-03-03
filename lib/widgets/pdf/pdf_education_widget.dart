import 'dart:typed_data';

import 'package:forte_life/widgets/pdf/pdf_subtitle.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';

class PDFWidgetEdu {
  Document createPDF(
    String title,
    String lpName,
    String lpAge,
    String lpGender,
    String lpOccupation,
    String pName,
    String pAge,
    String pGender,
    String pOccupation,
    String basicSA,
    String policyTerm,
    String paymentMode,
    String premium,
    bool isOnPolicy,
  ) {
    //Final variables
    final file = File(
            "/storage/emulated/0/Android/data/com.reahu.forte_life/files/logo.png")
        .readAsBytesSync();
    final image = MemoryImage(file);
    final Uint8List regularFont = File(
            '/storage/emulated/0/Android/data/com.reahu.forte_life/files/LiberationSans-Regular.ttf')
        .readAsBytesSync();

    final Uint8List boldFont = File(
            '/storage/emulated/0/Android/data/com.reahu.forte_life/files/LiberationSans-Bold.ttf')
        .readAsBytesSync();
    final regularData = regularFont.buffer.asByteData();
    final boldData = boldFont.buffer.asByteData();
    final regularF = Font.ttf(regularData);
    final boldF = Font.ttf(boldData);
    final Map<int, TableColumnWidth> columnWidthVal = {
      0: FlexColumnWidth(0.45),
      1: FlexColumnWidth(1.85),
      2: FlexColumnWidth(1.85),
      3: FlexColumnWidth(0.7),
      4: FlexColumnWidth(2.65)
    };

    //Doubles with no previous values
    double accumulatedPremium = 0;
    double accumulatedPremiumForCV = 0;
    double allCauses = 0;
    double cashValue = 0;
    //

    //Convert String to Double for ease of use
    double basicSANum = double.parse(basicSA);
    double premiumNum = double.parse(premium);
    double yearlyNum = double.parse(premium);
    //

    // Round all the doubles to a .00 decimal format

    double halfPNum = premiumNum * 0.5178;
    double quarterlyPNum = premiumNum * 0.2635;
    double monthlyPNum = premiumNum * 0.0888;
    String halfP = halfPNum.toStringAsFixed(2);
    String quarterlyP = quarterlyPNum.toStringAsFixed(2);
    String monthlyP = monthlyPNum.toStringAsFixed(2);
    String cashValueStr = cashValue.toStringAsFixed(2);
    //

    double getPremiumPayment(String paymentMode) {
      double premiumPayment = 0;
      switch (paymentMode) {
        case "Yearly":
          {
            premiumPayment = yearlyNum;
            break;
          }
        case "Half-yearly":
          {
            premiumPayment = halfPNum * 2;
            break;
          }
        case "Quarterly":
          {
            premiumPayment = quarterlyPNum * 4;
            break;
          }
        case "Monthly":
          {
            premiumPayment = monthlyPNum * 12;
            break;
          }
      }
      return premiumPayment;
    }

    double getGSB() {
      if (int.parse(pAge) < 50) {
        return (basicSANum * (double.parse(policyTerm) * 2) / 100);
      } else {
        return (basicSANum * double.parse(policyTerm) / 100);
      }
    }

    List<List<dynamic>> getDynamicRow(
        int policyYear, int age, String paymentMode) {
      List<List<dynamic>> dynamicRow = List();
      int i = 1;
      double cashValPercentage = 0;
      premiumNum = getPremiumPayment(paymentMode);
      accumulatedPremium += premiumNum;
      accumulatedPremiumForCV += yearlyNum;
      if (isOnPolicy == false) {
        age += 1;
      }
      //All causes and accidents, List initialization
      switch (age) {
        case 1:
          {
            allCauses = basicSANum * 0.4;
            dynamicRow = [
              [
                "$i",
                "$premiumNum            ${accumulatedPremium.toStringAsFixed(2)}",
                "${allCauses.toStringAsFixed(2)}",
                "-",
                "          -                              -                             -         "
              ],
            ];
            i++;
            allCauses = basicSANum * 0.6;
            accumulatedPremium += premiumNum;
            accumulatedPremiumForCV += yearlyNum;
            dynamicRow.add([
              "$i",
              "$premiumNum            ${accumulatedPremium.toStringAsFixed(2)}",
              "${allCauses.toStringAsFixed(2)}",
              "-",
              "          -                              -                             -         "
            ]);
            allCauses = basicSANum * 0.8;
            break;
          }
        case 2:
          {
            allCauses = basicSANum * 0.6;
            dynamicRow = [
              [
                "$i",
                "$premiumNum            ${accumulatedPremium.toStringAsFixed(2)}",
                "${allCauses.toStringAsFixed(2)}",
                "-",
                "          -                              -                             -         "
              ],
            ];
            i++;
            allCauses = basicSANum * 0.8;
            accumulatedPremium += premiumNum;
            accumulatedPremiumForCV += yearlyNum;
            dynamicRow.add([
              "$i",
              "$premiumNum            ${accumulatedPremium.toStringAsFixed(2)}",
              "${allCauses.toStringAsFixed(2)}",
              "-",
              "          -                              -                             -         "
            ]);
            allCauses = basicSANum;
            break;
          }
        case 3:
          {
            allCauses = basicSANum * 0.8;
            dynamicRow = [
              [
                "$i",
                "$premiumNum            ${accumulatedPremium.toStringAsFixed(2)}",
                "${allCauses.toStringAsFixed(2)}",
                "-",
                "          -                              -                             -         "
              ],
            ];
            allCauses = basicSANum;
            break;
          }

        default:
          {
            allCauses = basicSANum;
            dynamicRow = [
              [
                "$i",
                "$premiumNum            ${accumulatedPremium.toStringAsFixed(2)}",
                "${allCauses.toStringAsFixed(2)}",
                "-",
                "          -                              -                             -         "
              ]
            ];
            break;
          }
      }
      //
      i++;
      while (i <= policyYear) {
        accumulatedPremium += premiumNum;
        accumulatedPremiumForCV += yearlyNum;

        if (i >= 3) {
          if (i == 4) {
            allCauses = basicSANum;
          }
          if (i <= 16) {
            if (i <= 12)
              cashValPercentage += 0.05;
            else
              cashValPercentage += 0.1;
          }
          cashValue = accumulatedPremiumForCV * cashValPercentage;
          cashValueStr = cashValue.toStringAsFixed(2);
        } else
          cashValueStr = "-";
        if (i < policyYear) {
          dynamicRow.add([
            "$i",
            "$premiumNum            ${accumulatedPremium.toStringAsFixed(2)} ",
            "${allCauses.toStringAsFixed(2)}",
            cashValueStr,
            "          -                              -                             -         "
          ]);
          i++;
        } else {
          dynamicRow.add([
            "$i",
            "$premiumNum            ${accumulatedPremium.toStringAsFixed(2)}",
            "${allCauses.toStringAsFixed(2)}",
            cashValue.round().toStringAsFixed(2),
            "${basicSANum.toStringAsFixed(2)}               ${getGSB().toStringAsFixed(2)}               ${(basicSANum + getGSB()).toStringAsFixed(2)}"
          ]);
          i++;
        }
      }

      return dynamicRow;
    }

    List<String> getDynamicHeaders() {
      List<String> dynamicHeader = [
        "End of Policy Year",
        "                Premium (USD)\n\n       Annualized     Accumulated",
        "               Death/TPD (USD)\n\n                    All Causes",
        "      Cash\n      Value",
        "    Guaranteed          Guaranteed      Total Maturity" +
            "\n" +
            " Maturity Benefit   Special Benefit        Benefit"
      ];
      return dynamicHeader;
    }

    Document pdf = Document();
    pdf.addPage(Page(
        margin: EdgeInsets.symmetric(vertical: 7.5, horizontal: 20),
        pageFormat: PdfPageFormat.a4,
        build: (Context context) {
          return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              child: Expanded(
                  child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Image.provider(image,
                      width: 150, height: 80, fit: BoxFit.contain),
                  SizedBox(width: 15),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Flexible(
                        child: Text(
                            "Forte Life Assurance (Cambodia) Plc." +
                                "\n" +
                                "Vattanac Capital, Level 18 No.66 Monivong Blvd, Sangkat Wat Phnom," +
                                "\n" +
                                "Khan Daun Penh, Phnom Penh, Cambodia." +
                                "\n" +
                                "Tel: (+855) 23 885 077/ 066 Fax: (+855) 23 986 922" +
                                "\n" +
                                "Email: info@fortelifeassurance.com",
                            style: TextStyle(fontSize: 6.5, font: regularF))),
                  ),
                ]),
                SizedBox(height: 20),
                Text("SALES ILLUSTRATION",
                    style: TextStyle(
                        fontSize: 14.5,
                        font: boldF,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Center(
                    child: Column(children: [
                  Table(
                      border: TableBorder.ex(
                          horizontalInside: BorderSide(),
                          bottom: BorderSide(),
                          top: BorderSide(),
                          left: BorderSide(),
                          right: BorderSide()),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(children: [
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.5),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Container(width: 100),
                                    ),
                                    PDFSubtitle(title: "Name", font: boldF),
                                    PDFSubtitle(title: "Age", font: boldF),
                                    PDFSubtitle(title: "Gender", font: boldF),
                                    Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: PDFSubtitle(
                                          title: "Occupation", font: boldF),
                                    )
                                  ]))
                        ]),
                        TableRow(children: [
                          Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 5, bottom: 2.5, top: 2.5),
                                      child: Container(
                                          width: 100,
                                          child: Text("Life Proposed",
                                              style: TextStyle(
                                                  font: regularF,
                                                  fontSize: 8.25)))),
                                  PDFSubtitle(title: lpName, font: regularF),
                                  PDFSubtitle(title: lpAge, font: regularF),
                                  PDFSubtitle(title: lpGender, font: regularF),
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: PDFSubtitle(
                                        title: lpOccupation, font: regularF),
                                  )
                                ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.only(left: 5, bottom: 2.5),
                                      child: Container(
                                          width: 100,
                                          child: Text("Payor",
                                              style: TextStyle(
                                                  font: regularF,
                                                  fontSize: 8.25)))),
                                  PDFSubtitle(title: pName, font: regularF),
                                  PDFSubtitle(title: pAge, font: regularF),
                                  PDFSubtitle(title: pGender, font: regularF),
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: PDFSubtitle(
                                        title: pOccupation, font: regularF),
                                  )
                                ])
                          ])
                        ]),
                        TableRow(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: 100,
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text("Type of Benefits",
                                            style: TextStyle(
                                                font: boldF, fontSize: 8.25)))),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 5, bottom: 2.5, top: 2.5),
                                    child: PDFSubtitle(
                                        title: "Sum Insured", font: boldF)),
                                PDFSubtitle(title: "Policy Term", font: boldF),
                                PDFSubtitle(
                                    title: "Premium Paying Term", font: boldF),
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: PDFSubtitle(
                                      title: "Payment Mode", font: boldF),
                                )
                              ])
                        ]),
                        TableRow(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, bottom: 2.5, top: 2.5),
                                            child: Container(
                                                width: 117,
                                                child: Text(
                                                    "Basic Plan : $title",
                                                    style: TextStyle(
                                                        font: regularF,
                                                        fontSize: 8.25)))),
                                        SizedBox(
                                            width: 100,
                                            child: PDFSubtitle(
                                                title:
                                                    "USD ${basicSANum.toStringAsFixed(2)}",
                                                font: regularF)),
                                        SizedBox(width: 15),
                                        Padding(
                                          padding: EdgeInsets.only(left: 2),
                                          child: PDFSubtitle(
                                              title: policyTerm,
                                              font: regularF),
                                        ),
                                        SizedBox(width: 22),
                                        PDFSubtitle(
                                            title: policyTerm, font: regularF)
                                      ]),
                                ]),
                                Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: PDFSubtitle(
                                        title: paymentMode, font: regularF)),
                              ])
                        ]),
                        TableRow(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 5, top: 2.5, bottom: 2.5),
                                    child: Container(
                                        width: 103.55,
                                        child: Text("Premium",
                                            style: TextStyle(
                                                font: boldF, fontSize: 8.25))))
                              ])
                        ]),
                        TableRow(children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: 5, top: 2.5, bottom: 2.5),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 120,
                                      child: Text("Basic Plan : $title",
                                          style: TextStyle(
                                              font: regularF, fontSize: 8.25))),
                                  Padding(
                                    padding: EdgeInsets.only(left: 50),
                                    child: PDFSubtitle(
                                        title:
                                            "USD ${getPremiumPayment(paymentMode).toStringAsFixed(2)}",
                                        font: regularF),
                                  )
                                ]),
                          )
                        ]),
                        TableRow(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 5, top: 2.5, bottom: 2.5),
                                    child: Container(
                                        width: 120,
                                        child: Text("Total Premium",
                                            style: TextStyle(
                                                font: boldF, fontSize: 8.25)))),
                                Padding(
                                  padding: EdgeInsets.only(left: 50),
                                  child: PDFSubtitle(
                                      title:
                                          "USD ${getPremiumPayment(paymentMode).toStringAsFixed(2)}",
                                      font: regularF),
                                )
                              ])
                        ]),
                      ]),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.5),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("* Payment Modes:",
                            style: TextStyle(font: regularF, fontSize: 8.25))),
                  ),
                  Table(
                      border: TableBorder.ex(
                          horizontalInside: BorderSide(),
                          bottom: BorderSide(),
                          top: BorderSide(),
                          left: BorderSide(),
                          right: BorderSide()),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(children: [
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.5),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(children: [
                                      PDFSubtitle(
                                          title: "Yearly", font: regularF),
                                      PDFSubtitle(title: "USD $premiumNum")
                                    ]),
                                    Column(children: [
                                      PDFSubtitle(
                                          title: "Half-yearly", font: regularF),
                                      PDFSubtitle(title: "USD $halfP")
                                    ]),
                                    Column(children: [
                                      PDFSubtitle(
                                          title: "Quarterly", font: regularF),
                                      PDFSubtitle(title: "USD $quarterlyP")
                                    ]),
                                    Column(children: [
                                      PDFSubtitle(
                                          title: "Monthly", font: regularF),
                                      PDFSubtitle(title: "USD $monthlyP")
                                    ])
                                  ]))
                        ])
                      ]),
                  SizedBox(height: 15),
                  Table.fromTextArray(
                      headers: getDynamicHeaders(),
                      headerAlignment: Alignment.center,
                      columnWidths: columnWidthVal,
                      headerHeight: 20,
                      headerPadding: const EdgeInsets.only(
                          right: 1.5, bottom: 1.5, left: 1.5, top: 1.5),
                      cellHeight: 1.5,
                      cellPadding: EdgeInsets.only(
                          top: 3.5, right: 2.5, left: 2.5, bottom: 1.5),
                      headerStyle: TextStyle(font: boldF, fontSize: 8.25),
                      cellStyle: TextStyle(font: regularF, fontSize: 7.6),
                      cellAlignment: Alignment.topCenter,
                      headerDecoration:
                          BoxDecoration(border: Border(bottom: BorderSide())),
                      border: TableBorder.ex(
                          verticalInside: BorderSide(),
                          top: BorderSide(),
                          bottom: BorderSide(),
                          left: BorderSide(),
                          right: BorderSide()),
                      context: context,
                      data: getDynamicRow(int.parse(policyTerm),
                          int.parse(lpAge), paymentMode)),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Flexible(
                        child: Text(
                            "1.	This is a Non-participating Endowment plan with premium payables throughout the term of the Policy." +
                                "\n" +
                                "2.	The Guaranteed Special Benefit shall be equal to 2% of Basic Sum Assured multiplied by the Policy term with entry age below 50 years last birthday and 1% of Basic Sum Assured multiplied by the policy term with age 50 years last birthday and above." +
                                "\n" +
                                "3.	This Policy will acquire a Cash Value after it has been in-force for a minimum of two years." +
                                "\n" +
                                "4. 	The above is for illustration purposes only. The benefits described herein are subject to all terms and conditions contained in the Policy contract."
                                    "\n" +
                                "5.	Pays the earlier of either Death due to All Causes, TBD due too All Causes, Death due to Accident or TPD due to Accident.",
                            style: TextStyle(fontSize: 8.25, font: regularF))),
                  ),
                ]))
              ])));
        }));
    return pdf;
  }
}
