import 'dart:typed_data';

import 'package:forte_life/widgets/pdf/pdf_subtitle.dart';
import 'package:intl/intl.dart';
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
      String lang,
      String rootPath) {
    //Final variables
    final file = File("$rootPath/logo.png").readAsBytesSync();
    final file4 = File("$rootPath/money.png").readAsBytesSync();
    final file1 = File("$rootPath/piggybank.png").readAsBytesSync();
    final file3 = File("$rootPath/stats.png").readAsBytesSync();
    final file2 = File("$rootPath/umbrella.png").readAsBytesSync();

    final logo = MemoryImage(file);
    final header1 = MemoryImage(file1);
    final header2 = MemoryImage(file2);
    final header3 = MemoryImage(file3);
    final header4 = MemoryImage(file4);

    final Uint8List regularFont =
        File('$rootPath/LiberationSans-Regular.ttf').readAsBytesSync();

    final Uint8List boldFont =
        File('$rootPath/LiberationSans-Bold.ttf').readAsBytesSync();
    final Uint8List khmerFont = File("$rootPath/lmns7.ttf").readAsBytesSync();
    final Uint8List khmerBoldFont =
        File("$rootPath/LMNS4_0.TTF").readAsBytesSync();

    final regularData = regularFont.buffer.asByteData();
    final boldData = boldFont.buffer.asByteData();
    final khmerData = khmerFont.buffer.asByteData();
    final khmerBoldData = khmerBoldFont.buffer.asByteData();
    final regularF = Font.ttf(regularData);
    final boldF = Font.ttf(boldData);
    final khmerF = Font.ttf(khmerData);
    final khmerBoldF = Font.ttf(khmerBoldData);
    var myFormat = DateFormat('dd /MM /yyyy');
    var dateNow = DateTime.now();
    final currentDate = myFormat.format(dateNow);
    RegExp regExpNum = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    // final Map<int, TableColumnWidth> columnWidthVal = {
    //   0: FlexColumnWidth(0.6),
    //   1: FlexColumnWidth(1.85),
    //   2: FlexColumnWidth(1.4),
    //   3: FlexColumnWidth(0.825),
    //   4: FlexColumnWidth(2.825)
    // };
    final Map<int, TableColumnWidth> columnWidthValKh = {
      0: FlexColumnWidth(0.6),
      1: FlexColumnWidth(0.925),
      2: FlexColumnWidth(0.925),
      3: FlexColumnWidth(1.4),
      4: FlexColumnWidth(0.825),
      5: FlexColumnWidth(2.825)
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
    String halfP = halfPNum
        .toStringAsFixed(2)
        .replaceAllMapped(regExpNum, (Match m) => '${m[1]},');
    String quarterlyP = quarterlyPNum
        .toStringAsFixed(2)
        .replaceAllMapped(regExpNum, (Match m) => '${m[1]},');
    String monthlyP = monthlyPNum
        .toStringAsFixed(2)
        .replaceAllMapped(regExpNum, (Match m) => '${m[1]},');
    String cashValueStr = cashValue.toStringAsFixed(2);
    //

    List getPremiumPayment(String paymentMode) {
      double premiumPayment = 0;
      double truePremium = 0;
      String paymentModeStr;
      switch (paymentMode) {
        case "Yearly":
          {
            truePremium = yearlyNum;
            premiumPayment = yearlyNum;
            paymentModeStr = "RbcaMqÒaM";
            break;
          }
        case "Half-yearly":
          {
            truePremium = halfPNum;
            premiumPayment = halfPNum * 2;
            paymentModeStr = "RbcaMqmas";

            break;
          }
        case "Quarterly":
          {
            truePremium = quarterlyPNum;
            premiumPayment = quarterlyPNum * 4;
            paymentModeStr = "RbcaMRtImas";

            break;
          }
        case "Monthly":
          {
            truePremium = monthlyPNum;
            premiumPayment = monthlyPNum * 12;
            paymentModeStr = "RbcaMEx";

            break;
          }
      }
      List premiumAndSale = [premiumPayment, truePremium, paymentModeStr];
      return premiumAndSale;
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
      premiumNum = getPremiumPayment(paymentMode)[0];
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
                "${premiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
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
              "${premiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
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
                "${premiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
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
              "${premiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
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
                "${premiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
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
                "${premiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
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
          cashValueStr = cashValue
              .toStringAsFixed(2)
              .replaceAllMapped(regExpNum, (Match m) => '${m[1]},');
        } else
          cashValueStr = "-";
        if (i < policyYear) {
          dynamicRow.add([
            "$i",
            "${premiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            cashValueStr,
            "          -                              -                             -         "
          ]);
          i++;
        } else {
          dynamicRow.add([
            "$i",
            "${premiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            cashValue
                .round()
                .toStringAsFixed(2)
                .replaceAllMapped(regExpNum, (Match m) => '${m[1]},'),
            "${basicSANum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}           ${getGSB().toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}           ${(basicSANum + getGSB()).toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}"
          ]);
          i++;
        }
      }

      return dynamicRow;
    }

    List<List<dynamic>> getDynamicRowKh(
        int policyYear, int age, String paymentMode) {
      List<List<dynamic>> dynamicRow = List();
      int i = 1;
      double cashValPercentage = 0;
      premiumNum = getPremiumPayment(paymentMode)[0];
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
                "${premiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "-",
                "  -                                -                                -"
              ],
            ];
            i++;
            allCauses = basicSANum * 0.6;
            accumulatedPremium += premiumNum;
            accumulatedPremiumForCV += yearlyNum;
            dynamicRow.add([
              "$i",
              "${premiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "-",
              "  -                                -                                -"
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
                "${premiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "-",
                "  -                                -                                -"
              ],
            ];
            i++;
            allCauses = basicSANum * 0.8;
            accumulatedPremium += premiumNum;
            accumulatedPremiumForCV += yearlyNum;
            dynamicRow.add([
              "$i",
              "${premiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "-",
              "  -                                -                                -"
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
                "${premiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "-",
                "  -                                -                                -"
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
                "${premiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "-",
                "  -                                -                                -"
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
          cashValueStr = cashValue
              .toStringAsFixed(2)
              .replaceAllMapped(regExpNum, (Match m) => '${m[1]},');
        } else
          cashValueStr = "-";
        if (i < policyYear) {
          dynamicRow.add([
            "$i",
            "${premiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            "${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            cashValueStr,
            "  -                                -                                -"
          ]);
          i++;
        } else {
          dynamicRow.add([
            "$i",
            "${premiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            "${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            cashValue
                .round()
                .toStringAsFixed(2)
                .replaceAllMapped(regExpNum, (Match m) => '${m[1]},'),
            "${basicSANum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}           ${getGSB().toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}           ${(basicSANum + getGSB()).toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}"
          ]);
          i++;
        }
      }

      return dynamicRow;
    }

    Document pdf = Document();
    pdf.addPage(MultiPage(
        margin: EdgeInsets.symmetric(horizontal: 15),
        pageFormat: PdfPageFormat.a4,
        build: (Context context) => <Widget>[
              Wrap(children: [
                Container(
                    child: Expanded(
                        child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Image(logo, width: 150, height: 80, fit: BoxFit.contain),
                    SizedBox(width: 15),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Flexible(
                          child: lang != 'kh'
                              ? Text(
                                  "Forte Life Assurance (Cambodia) Plc." +
                                      "\n" +
                                      "Vattanac Capital, Level 18 No.66 Monivong Blvd, Sangkat Wat Phnom," +
                                      "\n" +
                                      "Khan Daun Penh, Phnom Penh, Cambodia." +
                                      "\n" +
                                      "Tel: (+855) 23 885 077/ 066 Fax: (+855) 23 986 922" +
                                      "\n" +
                                      "Email: info@fortelifeassurance.com",
                                  style:
                                      TextStyle(fontSize: 6.5, font: regularF))
                              : Expanded(
                                  child: Stack(children: [
                                  Text(
                                      "Rkúmh‘unFanar:ab;rgGayuCIvit hVtet LayhV_ GwsYruins_ exmbUDa mk",
                                      style: TextStyle(
                                          fontSize: 12, font: khmerF)),
                                  Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                          "GKar vDÆn³ kaBItal; Can;TI18 GKar66 mhavifIRBHmunñIvgS sgáat;vtþPñM",
                                          style: TextStyle(
                                              fontSize: 12, font: khmerF))),
                                  Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Text("xNÐdUneBj raCFanIPñMeBj",
                                          style: TextStyle(
                                              fontSize: 12, font: khmerF))),
                                  Padding(
                                      padding: EdgeInsets.only(top: 30),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("TUrs½BÞ",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    font: khmerF)),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 4.05),
                                              child: Text(
                                                  " : (+855) 23 885 077/ 066",
                                                  style: TextStyle(
                                                      fontSize: 6.5,
                                                      font: regularF)),
                                            ),
                                            Text(" TUrsar",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    font: khmerF)),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 3.7),
                                              child: Text(
                                                  " : (+855) 23 986 922",
                                                  style: TextStyle(
                                                      fontSize: 6.5,
                                                      font: regularF)),
                                            ),
                                          ])),
                                  Padding(
                                      padding: EdgeInsets.only(top: 40),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("sareGLicRtÚnic",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    font: khmerF)),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 3.65),
                                              child: Text(
                                                  " : info@fortelifeassurance.com",
                                                  style: TextStyle(
                                                      fontSize: 6.5,
                                                      font: regularF)),
                                            ),
                                          ]))
                                ]))),
                    ),
                  ]),
                  SizedBox(height: lang != 'kh' ? 20 : 5),
                  lang != 'kh'
                      ? Text("SALES ILLUSTRATION",
                          style: TextStyle(
                              fontSize: 14.5,
                              font: boldF,
                              fontWeight: FontWeight.bold))
                      : Text("taragbgðajGMBIplitpl",
                          style: TextStyle(fontSize: 25, font: khmerBoldF)),
                  SizedBox(height: lang != 'kh' ? 10 : 5),
                  Center(
                      child: Column(children: [
                    Table(
                        border: TableBorder(
                            horizontalInside: BorderSide(),
                            bottom: BorderSide(),
                            top: BorderSide(),
                            left: BorderSide(),
                            right: BorderSide()),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(children: [
                            lang != 'kh'
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.5),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Container(width: 100),
                                          ),
                                          SizedBox(width: 25),
                                          PDFSubtitle(
                                              isKhmer: false,
                                              title: "Name",
                                              font: boldF),
                                          PDFSubtitle(
                                              isKhmer: false,
                                              title: "Age",
                                              font: boldF),
                                          PDFSubtitle(
                                              isKhmer: false,
                                              title: "Gender",
                                              font: boldF),
                                          Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: PDFSubtitle(
                                                isKhmer: false,
                                                title: "Occupation",
                                                font: boldF),
                                          )
                                        ]))
                                : Stack(children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Container(width: 100),
                                          ),
                                          SizedBox(width: 45),
                                          PDFSubtitle(
                                              isKhmer: true,
                                              title: "eQµaH",
                                              font: khmerBoldF),
                                          PDFSubtitle(
                                              isKhmer: true,
                                              title: "Gayu",
                                              font: khmerBoldF),
                                          PDFSubtitle(
                                              isKhmer: true,
                                              title: "ePT",
                                              font: khmerBoldF),
                                          Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: PDFSubtitle(
                                                isKhmer: true,
                                                title: "muxrbr",
                                                font: khmerBoldF),
                                          )
                                        ])
                                  ])
                          ]),
                          TableRow(children: [
                            lang != 'kh'
                                ? Column(children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5,
                                                  bottom: 2.5,
                                                  top: 2.5),
                                              child: Container(
                                                  width: 100,
                                                  child: Text("Life Proposed",
                                                      style: TextStyle(
                                                          font: regularF,
                                                          fontSize: 8.25)))),
                                          SizedBox(width: 25),
                                          PDFSubtitle(
                                              isKhmer: false,
                                              title: lpName,
                                              font: regularF),
                                          PDFSubtitle(
                                              isKhmer: false,
                                              title: lpAge,
                                              font: regularF),
                                          PDFSubtitle(
                                              isKhmer: false,
                                              title: lpGender,
                                              font: regularF),
                                          Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: PDFSubtitle(
                                                isKhmer: false,
                                                title: lpOccupation,
                                                font: regularF),
                                          )
                                        ]),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5, bottom: 2.5),
                                              child: Container(
                                                  width: 100,
                                                  child: Text("Payor",
                                                      style: TextStyle(
                                                          font: regularF,
                                                          fontSize: 8.25)))),
                                          SizedBox(width: 25),
                                          PDFSubtitle(
                                              isKhmer: false,
                                              title: pName,
                                              font: regularF),
                                          PDFSubtitle(
                                              isKhmer: false,
                                              title: pAge,
                                              font: regularF),
                                          PDFSubtitle(
                                              isKhmer: false,
                                              title: pGender,
                                              font: regularF),
                                          Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: PDFSubtitle(
                                                isKhmer: false,
                                                title: pOccupation,
                                                font: regularF),
                                          )
                                        ])
                                  ])
                                : Stack(children: [
                                    Padding(
                                        padding: EdgeInsets.only(top: 14.5),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 5),
                                                  child: Container(
                                                      width: 100,
                                                      child: Text(
                                                          "Gñkbg;buBVlaPFanar:ab;rg",
                                                          style: TextStyle(
                                                              font: khmerF,
                                                              fontSize: 16)))),
                                              SizedBox(width: 45),
                                              PDFSubtitle(
                                                  isKhmer: false,
                                                  title: pName,
                                                  font: regularF),
                                              PDFSubtitle(
                                                  isKhmer: true,
                                                  title: pAge + "qñaM",
                                                  font: khmerF),
                                              PDFSubtitle(
                                                  isKhmer: true,
                                                  title: pGender == 'Male'
                                                      ? "Rbús"
                                                      : "RsI",
                                                  font: khmerF),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 5),
                                                child: PDFSubtitle(
                                                    isKhmer: false,
                                                    title: pOccupation,
                                                    font: regularF),
                                              )
                                            ])),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Container(
                                                  width: 100,
                                                  child: Text(
                                                      "GñkRtÚv)anFanar:ab;rgGayuCIvit",
                                                      style: TextStyle(
                                                          font: khmerF,
                                                          fontSize: 16)))),
                                          SizedBox(width: 45),
                                          PDFSubtitle(
                                              isKhmer: false,
                                              title: lpName,
                                              font: regularF),
                                          PDFSubtitle(
                                              isKhmer: true,
                                              title: lpAge + "qñaM",
                                              font: khmerF),
                                          PDFSubtitle(
                                              isKhmer: true,
                                              title: lpGender == 'Male'
                                                  ? "Rbús"
                                                  : "RsI",
                                              font: khmerF),
                                          Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: PDFSubtitle(
                                                isKhmer: true,
                                                title: "kUn",
                                                font: khmerF),
                                          )
                                        ])
                                  ])
                          ]),
                          TableRow(children: [
                            lang != 'kh'
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                        Container(
                                            width: 100,
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text("Type of Benefits",
                                                    style: TextStyle(
                                                        font: boldF,
                                                        fontSize: 8.25)))),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 45,
                                                bottom: 2.5,
                                                top: 2.5),
                                            child: PDFSubtitle(
                                                isKhmer: false,
                                                title: "Sum Assured",
                                                font: boldF)),
                                        PDFSubtitle(
                                            isKhmer: false,
                                            title: "Policy Term",
                                            font: boldF),
                                        PDFSubtitle(
                                            isKhmer: false,
                                            title: "Premium Paying Term",
                                            font: boldF),
                                        Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: PDFSubtitle(
                                              isKhmer: false,
                                              title: "Payment Mode",
                                              font: boldF),
                                        )
                                      ])
                                : Stack(children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              width: 100,
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                      "RbePTFanar:ab;rg",
                                                      style: TextStyle(
                                                          font: khmerBoldF,
                                                          fontSize: 16)))),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                left: 60,
                                              ),
                                              child: Stack(children: [
                                                PDFSubtitle(
                                                    isKhmer: true,
                                                    title:
                                                        "cMnYnTwkR)ak;RtÚv)an",
                                                    font: khmerBoldF),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10.5),
                                                    child: PDFSubtitle(
                                                        isKhmer: true,
                                                        title: "Fanar:ab;rg",
                                                        font: khmerBoldF))
                                              ])),
                                          Stack(children: [
                                            PDFSubtitle(
                                                isKhmer: true,
                                                title: "kalkMNt;énbNÑ",
                                                font: khmerBoldF),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10.5),
                                                child: PDFSubtitle(
                                                    isKhmer: true,
                                                    title: "snüar:ab;rg",
                                                    font: khmerBoldF))
                                          ]),
                                          Stack(children: [
                                            PDFSubtitle(
                                                isKhmer: true,
                                                title: "ry³eBlbg;buBVlaPFana",
                                                font: khmerBoldF),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10.5),
                                                child: PDFSubtitle(
                                                    isKhmer: true,
                                                    title: "r:ab;rg",
                                                    font: khmerBoldF))
                                          ]),
                                          Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: Stack(children: [
                                              PDFSubtitle(
                                                  isKhmer: true,
                                                  title: "rebobbg;buBVlaPFana",
                                                  font: khmerBoldF),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.5),
                                                  child: PDFSubtitle(
                                                      isKhmer: true,
                                                      title: "r:ab;rg",
                                                      font: khmerBoldF))
                                            ]),
                                          )
                                        ])
                                  ])
                          ]),
                          TableRow(children: [
                            lang != 'kh'
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                        Column(children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5,
                                                        bottom: 2.5,
                                                        top: 2.5),
                                                    child: Container(
                                                        width: 140,
                                                        child: Text(
                                                            "Basic Plan : $title",
                                                            style: TextStyle(
                                                                font: regularF,
                                                                fontSize:
                                                                    8.25)))),
                                                SizedBox(width: 10),
                                                SizedBox(
                                                    width: 100,
                                                    child: PDFSubtitle(
                                                        isKhmer: false,
                                                        title:
                                                            "USD ${basicSANum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                                                        font: regularF)),
                                                SizedBox(width: 7.5),
                                                PDFSubtitle(
                                                    isKhmer: false,
                                                    title: policyTerm,
                                                    font: regularF),
                                                SizedBox(width: 14.5),
                                                PDFSubtitle(
                                                    isKhmer: false,
                                                    title: policyTerm,
                                                    font: regularF)
                                              ]),
                                        ]),
                                        Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: PDFSubtitle(
                                                isKhmer: false,
                                                title: paymentMode,
                                                font: regularF)),
                                      ])
                                : Stack(children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                left: 5,
                                              ),
                                              child: Container(
                                                  width: 140,
                                                  child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text("KeRmagmUldæan",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                font: khmerF)),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 4.8),
                                                            child: Text(" : ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        8.25,
                                                                    font:
                                                                        regularF))),
                                                        Text(
                                                            "GayuCIvitsRmab;karsikSa-18",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                font: khmerF))
                                                      ]))),
                                          SizedBox(width: 25),
                                          SizedBox(
                                              width: 75,
                                              child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5.25),
                                                        child: Text(
                                                            "${basicSANum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')} ",
                                                            style: TextStyle(
                                                                fontSize: 8.25,
                                                                font:
                                                                    regularF))),
                                                    Text("duløar",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            font: khmerF)),
                                                  ])),
                                          PDFSubtitle(
                                              isKhmer: true,
                                              title: policyTerm + "qñaM",
                                              font: khmerF),
                                          PDFSubtitle(
                                              isKhmer: true,
                                              title: policyTerm + "qñaM",
                                              font: khmerF),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(right: 5),
                                              child: PDFSubtitle(
                                                  isKhmer: true,
                                                  title: getPremiumPayment(
                                                      paymentMode)[2],
                                                  font: khmerF)),
                                        ])
                                  ])
                          ]),
                          TableRow(children: [
                            lang != 'kh'
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, top: 2.5, bottom: 2.5),
                                            child: Container(
                                                width: 103.55,
                                                child: Text("Premium",
                                                    style: TextStyle(
                                                        font: boldF,
                                                        fontSize: 8.25))))
                                      ])
                                : Stack(children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text("buBVlaPFanar:ab;rg",
                                                  style: TextStyle(
                                                      font: khmerBoldF,
                                                      fontSize: 16)))
                                        ])
                                  ])
                          ]),
                          TableRow(children: [
                            lang != 'kh'
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 5, top: 2.5, bottom: 2.5),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              width: 140,
                                              child: Text("Basic Plan : $title",
                                                  style: TextStyle(
                                                      font: regularF,
                                                      fontSize: 8.25))),
                                          Padding(
                                            padding: EdgeInsets.only(left: 50),
                                            child: PDFSubtitle(
                                                isKhmer: false,
                                                title:
                                                    "USD ${getPremiumPayment(paymentMode)[1].toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                                                font: regularF),
                                          )
                                        ]),
                                  )
                                : Stack(children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(left: 5),
                                              width: 120,
                                              child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("KeRmagmUldæan",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            font: khmerF)),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 4.8),
                                                        child: Text(" : ",
                                                            style: TextStyle(
                                                                fontSize: 8.25,
                                                                font:
                                                                    regularF))),
                                                    Text(
                                                        "GayuCIvitsRmab;karsikSa-18",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            font: khmerF))
                                                  ])),
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5.25, left: 70),
                                                    child: Text(
                                                        "${getPremiumPayment(paymentMode)[1].toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')} ",
                                                        style: TextStyle(
                                                            fontSize: 8.25,
                                                            font: regularF))),
                                                Text("duløar",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        font: khmerF)),
                                              ])
                                        ]),
                                  ])
                          ]),
                          TableRow(children: [
                            lang != 'kh'
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 5, top: 2.5, bottom: 2.5),
                                            child: Container(
                                                width: 120,
                                                child: Text("Total Premium",
                                                    style: TextStyle(
                                                        font: boldF,
                                                        fontSize: 8.25)))),
                                        Padding(
                                          padding: EdgeInsets.only(left: 70),
                                          child: PDFSubtitle(
                                              isKhmer: false,
                                              title:
                                                  "USD ${getPremiumPayment(paymentMode)[1].toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                                              font: regularF),
                                        )
                                      ])
                                : Stack(children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Container(
                                                  width: 120,
                                                  child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "buBVlaPFanar:ab;rgsrub",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                font:
                                                                    khmerBoldF)),
                                                      ]))),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 70),
                                              child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5.25),
                                                        child: Text(
                                                            "${getPremiumPayment(paymentMode)[1].toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')} ",
                                                            style: TextStyle(
                                                                fontSize: 8.25,
                                                                font:
                                                                    regularF))),
                                                    Text("duløar",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            font: khmerF)),
                                                  ]))
                                        ])
                                  ])
                          ]),
                        ]),
                    lang != 'kh'
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.5),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("* Payment Modes:",
                                    style: TextStyle(
                                        font: regularF, fontSize: 8.25))),
                          )
                        : Stack(children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Row(children: [
                                  Text("* ",
                                      style: TextStyle(
                                          fontSize: 8.25, font: regularF)),
                                  Text(
                                      "taragbuBVlaPFanar:ab;rgtamrebobbg;buBVlaPFanar:ab;rg",
                                      style: TextStyle(
                                          font: khmerF, fontSize: 16)),
                                  Padding(
                                      padding: EdgeInsets.only(top: 1.35),
                                      child: Text(" :",
                                          style: TextStyle(
                                              fontSize: 8.25, font: regularF))),
                                ]))
                          ]),
                    Table(
                        border: TableBorder(
                            horizontalInside: BorderSide(),
                            bottom: BorderSide(),
                            top: BorderSide(),
                            left: BorderSide(),
                            right: BorderSide()),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(children: [
                            lang != 'kh'
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.5),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(children: [
                                            PDFSubtitle(
                                                isKhmer: false,
                                                title: "Yearly",
                                                font: regularF),
                                            PDFSubtitle(
                                                isKhmer: false,
                                                title:
                                                    "USD ${premiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}")
                                          ]),
                                          Column(children: [
                                            PDFSubtitle(
                                                isKhmer: false,
                                                title: "Half-yearly",
                                                font: regularF),
                                            PDFSubtitle(
                                                isKhmer: false,
                                                title: "USD $halfP")
                                          ]),
                                          Column(children: [
                                            PDFSubtitle(
                                                isKhmer: false,
                                                title: "Quarterly",
                                                font: regularF),
                                            PDFSubtitle(
                                                isKhmer: false,
                                                title: "USD $quarterlyP")
                                          ]),
                                          Column(children: [
                                            PDFSubtitle(
                                                isKhmer: false,
                                                title: "Monthly",
                                                font: regularF),
                                            PDFSubtitle(
                                                isKhmer: false,
                                                title: "USD $monthlyP")
                                          ])
                                        ]))
                                : Stack(children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                PDFSubtitle(
                                                    isKhmer: true,
                                                    title: "RbcaMqÒaM",
                                                    font: khmerF),
                                                Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            top: 5.25,
                                                          ),
                                                          child: Text(
                                                              "${getPremiumPayment(paymentMode)[1].toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')} ",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      8.25,
                                                                  font:
                                                                      regularF))),
                                                      Text("duløar",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              font: khmerF)),
                                                    ])
                                              ]),
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                PDFSubtitle(
                                                    isKhmer: true,
                                                    title: "RbcaMqmas",
                                                    font: khmerF),
                                                Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5.25),
                                                          child: Text("$halfP ",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      8.25,
                                                                  font:
                                                                      regularF))),
                                                      Text("duløar",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              font: khmerF)),
                                                    ])
                                              ]),
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                PDFSubtitle(
                                                    isKhmer: true,
                                                    title: "RbcaMRtImas",
                                                    font: khmerF),
                                                Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5.25),
                                                          child: Text(
                                                              "$quarterlyP ",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      8.25,
                                                                  font:
                                                                      regularF))),
                                                      Text("duløar",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              font: khmerF)),
                                                    ])
                                              ]),
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                PDFSubtitle(
                                                    isKhmer: true,
                                                    title: "RbcaMEx",
                                                    font: khmerF),
                                                Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5.25),
                                                          child: Text(
                                                              "$monthlyP ",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      8.25,
                                                                  font:
                                                                      regularF))),
                                                      Text("duløar",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              font: khmerF)),
                                                    ])
                                              ]),
                                        ])
                                  ])
                          ])
                        ]),
                    SizedBox(height: lang != 'kh' ? 12.5 : 8.5),
                    lang != 'kh'
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Table(children: [
                                  TableRow(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      decoration: BoxDecoration(
                                          border: TableBorder(
                                              verticalInside: BorderSide(),
                                              top: BorderSide(),
                                              bottom: BorderSide(),
                                              left: BorderSide(),
                                              right: BorderSide())),
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2.5),
                                                  alignment:
                                                      Alignment.topCenter,
                                                  decoration: BoxDecoration(
                                                      border: TableBorder(
                                                          right: BorderSide())),
                                                  width: 45.2,
                                                  height: 95,
                                                  child: Text(
                                                      "End of\nPolicy\nYear",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          font: boldF,
                                                          fontSize: 8.25))),
                                              Container(
                                                height: 95,
                                                width: 139.36,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.5),
                                                decoration: BoxDecoration(
                                                    border: TableBorder(
                                                        right: BorderSide())),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("Premium (USD)",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              font: boldF,
                                                              fontSize: 8.25)),
                                                      Image(header1,
                                                          width: 35,
                                                          height: 45,
                                                          fit: BoxFit.contain),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 6),
                                                              child: Text(
                                                                  "Annualized",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      font:
                                                                          boldF,
                                                                      fontSize:
                                                                          8.25)),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  "Accumulated",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      font:
                                                                          boldF,
                                                                      fontSize:
                                                                          8.25)),
                                                            )
                                                          ]),
                                                    ]),
                                              ),
                                              Container(
                                                height: 95,
                                                width: 105.48,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.5),
                                                decoration: BoxDecoration(
                                                    border: TableBorder(
                                                        right: BorderSide())),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("Death/TPD (USD)",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              font: boldF,
                                                              fontSize: 8.25)),
                                                      Image(header2,
                                                          width: 35,
                                                          height: 45,
                                                          fit: BoxFit.contain),
                                                      Text("All Causes",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              font: boldF,
                                                              fontSize: 8.25)),
                                                    ]),
                                              ),
                                              Container(
                                                height: 95,
                                                width: 62.16,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.5),
                                                decoration: BoxDecoration(
                                                    border: TableBorder(
                                                        right: BorderSide())),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("Cash Value",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              font: boldF,
                                                              fontSize: 8.25)),
                                                      Image(header3,
                                                          width: 30,
                                                          height: 40,
                                                          fit: BoxFit.contain),
                                                      Text("(USD)",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              font: boldF,
                                                              fontSize: 8.25)),
                                                    ]),
                                              ),
                                              Container(
                                                  height: 95,
                                                  width: 212.82,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2.5),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                  children: [
                                                                    Text(
                                                                        "Guaranteed",
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style: TextStyle(
                                                                            font:
                                                                                boldF,
                                                                            fontSize:
                                                                                8.25)),
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                              top: 10),
                                                                      child: Text(
                                                                          "Maturity Benefit",
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style: TextStyle(
                                                                              font: boldF,
                                                                              fontSize: 8.25)),
                                                                    )
                                                                  ]),
                                                              Text("(USD)",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      font:
                                                                          boldF,
                                                                      fontSize:
                                                                          8.25)),
                                                            ]),
                                                        Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                  children: [
                                                                    Text(
                                                                        "Guaranteed",
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style: TextStyle(
                                                                            font:
                                                                                boldF,
                                                                            fontSize:
                                                                                8.25)),
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                              top: 10),
                                                                      child: Text(
                                                                          "Special Benefit",
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style: TextStyle(
                                                                              font: boldF,
                                                                              fontSize: 8.25)),
                                                                    )
                                                                  ]),
                                                              Image(header4,
                                                                  width: 30,
                                                                  height: 40,
                                                                  fit: BoxFit
                                                                      .contain),
                                                              Text("(USD)",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      font:
                                                                          boldF,
                                                                      fontSize:
                                                                          8.25)),
                                                            ]),
                                                        Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                  children: [
                                                                    Text(
                                                                        "Total Maturity",
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style: TextStyle(
                                                                            font:
                                                                                boldF,
                                                                            fontSize:
                                                                                8.25)),
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                              top: 10),
                                                                      child: Text(
                                                                          "Benefit",
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style: TextStyle(
                                                                              font: boldF,
                                                                              fontSize: 8.25)),
                                                                    )
                                                                  ]),
                                                              Text("(USD)",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      font:
                                                                          boldF,
                                                                      fontSize:
                                                                          8.25)),
                                                            ]),
                                                      ])),
                                            ])
                                      ]),
                                ]),
                                Table.fromTextArray(
                                    headerAlignment: Alignment.topCenter,
                                    columnWidths: columnWidthValKh,
                                    headerHeight: 0.05,
                                    headerPadding: const EdgeInsets.only(
                                        top: 2,
                                        right: 2.5,
                                        left: 2.5,
                                        bottom: 1.5),
                                    cellHeight: 0.05,
                                    cellPadding: EdgeInsets.only(
                                        top: 2,
                                        right: 2.5,
                                        left: 2.5,
                                        bottom: 1.5),
                                    headerStyle: TextStyle(
                                        font: regularF, fontSize: 7.6),
                                    cellStyle: TextStyle(
                                        font: regularF, fontSize: 7.6),
                                    cellAlignment: Alignment.topCenter,
                                    border: TableBorder(
                                        verticalInside: BorderSide(),
                                        top: BorderSide(),
                                        bottom: BorderSide(),
                                        left: BorderSide(),
                                        right: BorderSide()),
                                    context: context,
                                    data: getDynamicRowKh(int.parse(policyTerm),
                                        int.parse(lpAge), paymentMode))
                              ])
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Table(children: [
                                  TableRow(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      decoration: BoxDecoration(
                                          border: TableBorder(
                                              verticalInside: BorderSide(),
                                              top: BorderSide(),
                                              bottom: BorderSide(),
                                              left: BorderSide(),
                                              right: BorderSide())),
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                      border: TableBorder(
                                                          right: BorderSide())),
                                                  width: 45.2,
                                                  height: 95,
                                                  child: Stack(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      children: [
                                                        Text("enAcugqÒaM",
                                                            style: TextStyle(
                                                                font:
                                                                    khmerBoldF,
                                                                fontSize: 16)),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 12.5),
                                                            child: Text(
                                                                "bNÑsnüa",
                                                                style: TextStyle(
                                                                    font:
                                                                        khmerBoldF,
                                                                    fontSize:
                                                                        16))),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 25),
                                                            child: Text(
                                                                "r:ab;rg",
                                                                style: TextStyle(
                                                                    font:
                                                                        khmerBoldF,
                                                                    fontSize:
                                                                        16)))
                                                      ])),
                                              Container(
                                                height: 95,
                                                width: 139.36,
                                                decoration: BoxDecoration(
                                                    border: TableBorder(
                                                        right: BorderSide())),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Stack(
                                                          alignment: Alignment
                                                              .topCenter,
                                                          children: [
                                                            Text(
                                                                "buBVlaPFanar:ab;rg",
                                                                style: TextStyle(
                                                                    font:
                                                                        khmerBoldF,
                                                                    fontSize:
                                                                        16)),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            12.5),
                                                                child: Text(
                                                                    "¬duløar¦",
                                                                    style: TextStyle(
                                                                        font:
                                                                            khmerBoldF,
                                                                        fontSize:
                                                                            16))),
                                                          ]),
                                                      Image(header1,
                                                          width: 35,
                                                          height: 45,
                                                          fit: BoxFit.contain),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            8.75),
                                                                child: Text(
                                                                    "bg;RbcaMqñaM",
                                                                    style: TextStyle(
                                                                        font:
                                                                            khmerBoldF,
                                                                        fontSize:
                                                                            16))),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  "srubEdl)anbg;",
                                                                  style: TextStyle(
                                                                      font:
                                                                          khmerBoldF,
                                                                      fontSize:
                                                                          16)),
                                                            )
                                                          ]),
                                                    ]),
                                              ),
                                              Container(
                                                height: 95,
                                                width: 105.48,
                                                decoration: BoxDecoration(
                                                    border: TableBorder(
                                                        right: BorderSide())),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Stack(
                                                          alignment: Alignment
                                                              .topCenter,
                                                          children: [
                                                            Text(
                                                                "GtßRbeyaCn_mrNPaBnigBikarPaB",
                                                                style: TextStyle(
                                                                    font:
                                                                        khmerBoldF,
                                                                    fontSize:
                                                                        16)),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            12.5),
                                                                child: Text(
                                                                    "TaMgRsúgnigCaGciéRnþy_¬duløar¦",
                                                                    style: TextStyle(
                                                                        font:
                                                                            khmerBoldF,
                                                                        fontSize:
                                                                            16))),
                                                          ]),
                                                      Image(header2,
                                                          width: 35,
                                                          height: 45,
                                                          fit: BoxFit.contain),
                                                      Text("RKb;mUlehtu",
                                                          style: TextStyle(
                                                              font: khmerBoldF,
                                                              fontSize: 16)),
                                                    ]),
                                              ),
                                              Container(
                                                height: 95,
                                                width: 62.16,
                                                decoration: BoxDecoration(
                                                    border: TableBorder(
                                                        right: BorderSide())),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Stack(
                                                          alignment: Alignment
                                                              .topCenter,
                                                          children: [
                                                            Text("témø",
                                                                style: TextStyle(
                                                                    font:
                                                                        khmerBoldF,
                                                                    fontSize:
                                                                        16)),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            12.5),
                                                                child: Text(
                                                                    "sac;R)ak;",
                                                                    style: TextStyle(
                                                                        font:
                                                                            khmerBoldF,
                                                                        fontSize:
                                                                            16))),
                                                          ]),
                                                      Image(header3,
                                                          width: 30,
                                                          height: 40,
                                                          fit: BoxFit.contain),
                                                      Text("¬duløar¦",
                                                          style: TextStyle(
                                                              font: khmerBoldF,
                                                              fontSize: 16)),
                                                    ]),
                                              ),
                                              Container(
                                                  height: 95,
                                                  width: 212.82,
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                  children: [
                                                                    Text(
                                                                        "GtßRbeyaCn_dl;",
                                                                        style: TextStyle(
                                                                            font:
                                                                                khmerBoldF,
                                                                            fontSize:
                                                                                16)),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                12.5),
                                                                        child: Text(
                                                                            "kalkMNt;RtÚv)an",
                                                                            style:
                                                                                TextStyle(font: khmerBoldF, fontSize: 16))),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                25),
                                                                        child: Text(
                                                                            "Fana",
                                                                            style:
                                                                                TextStyle(font: khmerBoldF, fontSize: 16))),
                                                                  ]),
                                                              Text("¬duløar¦",
                                                                  style: TextStyle(
                                                                      font:
                                                                          khmerBoldF,
                                                                      fontSize:
                                                                          16))
                                                            ]),
                                                        Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                  children: [
                                                                    Text(
                                                                        "GtßRbeyaCn_",
                                                                        style: TextStyle(
                                                                            font:
                                                                                khmerBoldF,
                                                                            fontSize:
                                                                                16)),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                12.5),
                                                                        child: Text(
                                                                            "BiessRtÚv)an",
                                                                            style:
                                                                                TextStyle(font: khmerBoldF, fontSize: 16))),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                25),
                                                                        child: Text(
                                                                            "Fana",
                                                                            style:
                                                                                TextStyle(font: khmerBoldF, fontSize: 16))),
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                              top: 41),
                                                                      child: Image(
                                                                          header4,
                                                                          width:
                                                                              32.5,
                                                                          height:
                                                                              40,
                                                                          fit: BoxFit
                                                                              .contain),
                                                                    )
                                                                  ]),
                                                              Text("¬duløar¦",
                                                                  style: TextStyle(
                                                                      font:
                                                                          khmerBoldF,
                                                                      fontSize:
                                                                          16))
                                                            ]),
                                                        Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter,
                                                                  children: [
                                                                    Text(
                                                                        "GtßRbeyaCn_dl;",
                                                                        style: TextStyle(
                                                                            font:
                                                                                khmerBoldF,
                                                                            fontSize:
                                                                                16)),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                12.5),
                                                                        child: Text(
                                                                            "kalkMNt;bUknwg",
                                                                            style:
                                                                                TextStyle(font: khmerBoldF, fontSize: 16))),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                25),
                                                                        child: Text(
                                                                            "GtßRbeyaCn_",
                                                                            style:
                                                                                TextStyle(font: khmerBoldF, fontSize: 16))),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                37.5),
                                                                        child: Text(
                                                                            "Biess",
                                                                            style:
                                                                                TextStyle(font: khmerBoldF, fontSize: 16))),
                                                                  ]),
                                                              Text("¬duløar¦",
                                                                  style: TextStyle(
                                                                      font:
                                                                          khmerBoldF,
                                                                      fontSize:
                                                                          16))
                                                            ]),
                                                      ])),
                                            ])
                                      ]),
                                ]),
                                Table.fromTextArray(
                                    headerAlignment: Alignment.topCenter,
                                    columnWidths: columnWidthValKh,
                                    headerHeight: 0.05,
                                    headerPadding: const EdgeInsets.only(
                                        top: 2,
                                        right: 2.5,
                                        left: 2.5,
                                        bottom: 1.5),
                                    cellHeight: 0.05,
                                    cellPadding: EdgeInsets.only(
                                        top: 2,
                                        right: 2.5,
                                        left: 2.5,
                                        bottom: 1.5),
                                    headerStyle: TextStyle(
                                        font: regularF, fontSize: 7.6),
                                    cellStyle: TextStyle(
                                        font: regularF, fontSize: 7.6),
                                    cellAlignment: Alignment.topCenter,
                                    border: TableBorder(
                                        verticalInside: BorderSide(),
                                        top: BorderSide(),
                                        bottom: BorderSide(),
                                        left: BorderSide(),
                                        right: BorderSide()),
                                    context: context,
                                    data: getDynamicRowKh(int.parse(policyTerm),
                                        int.parse(lpAge), paymentMode))
                              ]),
                    lang != 'kh'
                        ? Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Flexible(
                                child: Text(
                                    "1.	This is a Non-participating Endowment plan with premiums payable throughout the term of the policy." +
                                        "\n" +
                                        "2.	The Guaranteed Special Benefit shall be equal to 2% of Basic Sum Assured multiplied by the Policy term for Payor with entry age below 50 years last birthday and 1% of Basic Sum Assured multiplied by the policy term for Payor age 50 years last birthday and above." +
                                        "\n" +
                                        "3.	The Guaranteed Maturity Benefit will be payable at the end of the policy term." +
                                        "\n" +
                                        "4. This policy will acquire a Cash Value after it has been in-force for a minimum of two (2) years" +
                                        "\n" +
                                        "5.	Upon the Life Assured attaining the age of 12, an Education Cash Allowance of USD 100 will be available to the policy owner." +
                                        "\n" +
                                        "6. Upon the death or total and permanent disablement (as defined in the policy) of the Payor and subject to the terms and conditions in the policy contract, all premiums will be waived until the policy matures." +
                                        "\n" +
                                        "7. The above are for illustration purposes only. The benefits described herein are subject to all the terms and conditions contained in the policy contract." +
                                        "\n\n" +
                                        "Note: This Sales Illustration shall be expired 30 days after print date below." +
                                        "\n\n\n" +
                                        "Print Date               : $currentDate",
                                    style: TextStyle(
                                        fontSize: 8.25, font: regularF))),
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Stack(children: [
                              Text(
                                  "¬k¦ enHKWCaKeRmagFanar:ab;rgTayC¢TanEdlminmankarcUlrYmEbgEckPaKlaPCamYyRkúmh‘unEdlkarbg;buBVlaPFanar:ab;rgeTAtamkalkMNt;énbNÑsnüar:ab;rg.",
                                  style: TextStyle(fontSize: 13, font: khmerF)),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                    "¬x¦ GtßRbeyaCn_BiessRtÚv)anFana RtÚv)anKNnaedayykGRtakarR)ak; @°énTwkR)ak;Fanar:ab;rg KuNnwgcMnYnqñaMénkalkMNt;énbNÑsnüar:ab;rg sRmab;Gñkbg;buBVlaPFanar:ab;rgEdlmanGayuenAeBlcab;epþImFana",
                                    style:
                                        TextStyle(fontSize: 13, font: khmerF)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text(
                                    "eRkam%0qñaMKitRtwméf¶xYbkMeNItcugeRkayedayELksRmab;Gñkbg;buBVlaPFanar:ab;rgEdlmanGayuenAeBlcab;epþImFanacab;BI %0qñaMeLIgeTAKitRtwméf¶xYbkMeNItcugeRkayGRtakarR)ak;!°énTwkR)ak;Fanar:ab;rgKuNnwgcMnYn",
                                    style:
                                        TextStyle(fontSize: 13, font: khmerF)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: Text(
                                    "qñaMénkalkMNt;énbNÑsnüar:ab;rgnwgRtÚv)anykmkKNna.GtßRbeyaCn_BiessRtÚv)anFananwgRtÚvTUTat;EteBldl;kalkMNt;énbNÑsnüar:ab;rgb:ueNÑaH.",
                                    style:
                                        TextStyle(fontSize: 13, font: khmerF)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Text(
                                    "¬K¦ GtßRbeyaCn_dl;kalkMNt;RtÚv)anFanaEdlmantémøesµIKñanwgTwkR)ak;RtÚv)anFanar:ab;rgsrubnwgRtÚv)anTUTat;enAcugbBa©b;énkalkMNt;énbNÑsnüar:ab;rg.",
                                    style:
                                        TextStyle(fontSize: 13, font: khmerF)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Text(
                                    "¬X¦ bNÑsnüar:ab;rgenHnwgTTYl)annUvtémøsac;R)ak; bnÞab;BIbNÑsnüar:ab;rgenHRtÚv)ancUlCaFrmankñúgry³eBly:agtic @qñaM.",
                                    style:
                                        TextStyle(fontSize: 13, font: khmerF)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 60),
                                child: Text(
                                    "¬g¦ enAeBlkUnmanGayu !@qñaM R)ak;elIkTwkcitþsRmab;karsikSacMnYn !00duløar nwgRtÚv)anpþl;CUneTAm©as;bNÑsnüar:ab;rg. m©as;bNÑsnüar:ab;rgnwgmanCeRmIskñúgkardkR)ak; b¤epJIR)ak;TukedIm,IbgÁrR)ak;cMnYn !00duløar",
                                    style:
                                        TextStyle(fontSize: 13, font: khmerF)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 70),
                                child: Text(
                                    "bUkbBa©ÚlCamYytémøTwkR)ak;EdlmannigGtßRbeyaCn_dl;kalkMNt;EdlRtÚv)anFanaCamYynwgRkúmh‘un.",
                                    style:
                                        TextStyle(fontSize: 13, font: khmerF)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 80),
                                child: Text(
                                    "¬c¦ kñúgkrNIEdlGñkbg;buBVlaPFanar:ab;rgTTYlmrNPaBb¤BikarPaBTaMgRsúgnigCaGciRnéþy_buBVlaPFanar:ab;rgTaMgGs;naeBlGnaKtGnuelamtambNÑsnüar:ab;rgenHnwgminRtÚv)antRmÚv[bg;bnþeToteLIy.",
                                    style:
                                        TextStyle(fontSize: 13, font: khmerF)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 90),
                                child: Text(
                                    "¬q¦ xagelIenHCakarbgðajGMBIplitplFanar:ab;rgEtb:ueNÑaH. GtßRbeyaCn_Edl)anBiBN’naenATIenH KWRtÚvGnuelamtam x niglkçxNÐTaMgGs;EdlmanEcgenAkñúgkic©snüar:ab;rg.",
                                    style:
                                        TextStyle(fontSize: 13, font: khmerF)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 105),
                                child: Text(
                                    "sMKal;³ taragsmÁal;bgðajBIplitplenHnwgRtÚvGs;suBlPaBry³eBl30éf¶eRkaykalbriecäTe)aHBum<xageRkam.",
                                    style:
                                        TextStyle(fontSize: 13, font: khmerF)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 120),
                                child: Row(children: [
                                  Text("kalbriecäTe)aHBum<        ",
                                      style: TextStyle(
                                          fontSize: 13, font: khmerF)),
                                  Padding(
                                      padding: EdgeInsets.only(top: 1),
                                      child: Text(": $currentDate",
                                          style: TextStyle(
                                              fontSize: 6.5, font: boldF))),
                                ]),
                              ),
                            ]),
                          )
                  ]))
                ]))),
                // Padding(
                //   padding: EdgeInsets.only(top: 100),
                //   child: Flexible(
                //       child: Text(
                //           "1.	This is a Non-participating Endowment plan with premiums payable throughout the term of the policy." +
                //               "\n" +
                //               "2.	The Guaranteed Special Benefit shall be equal to 2% of Basic Sum Assured multiplied by the Policy term for Payor with entry age below 50 years last birthday and 1% of Basic Sum Assured multiplied by the policy term for Payor age 50 years last birthday and above." +
                //               "\n" +
                //               "3.	The Guaranteed Maturity Benefit will be payable at the end of the policy term." +
                //               "\n" +
                //               "4. This policy will acquire a Cash Value after it has been in-force for a minimum of two (2) years" +
                //               "\n" +
                //               "5.	Upon the Life Assured attaining the age of 12, an Education Cash Allowance of USD 100 will be available to the policy owner." +
                //               "\n" +
                //               "6. Upon the death or total and permanent disablement (as defined in the policy) of the Payor and subject to the terms and conditions in the policy contract, all premiums will be waived until the policy matures." +
                //               "\n" +
                //               "7. The above are for illustration purposes only. The benefits described herein are subject to all the terms and conditions contained in the policy contract." +
                //               "\n\n" +
                //               "Note: This Sales Illustration shall be expired 30 days after print date below." +
                //               "\n\n\n" +
                //               "Print Date               : $currentDate",
                //           style: TextStyle(fontSize: 8.25, font: regularF))),
                // ),
              ])
            ]));
    return pdf;
  }
}
