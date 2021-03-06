import 'dart:convert';
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
    final pNameFile = File("$rootPath/word.png").readAsBytesSync();
    final lPNameFile = File("$rootPath/wordLP.png").readAsBytesSync();
    final occFile = File("$rootPath/wordOcc.png").readAsBytesSync();

    final logo = MemoryImage(file);
    final header1 = MemoryImage(file1);
    final header2 = MemoryImage(file2);
    final header3 = MemoryImage(file3);
    final header4 = MemoryImage(file4);
    final pNameImg = MemoryImage(pNameFile);
    final lpNameImg = MemoryImage(lPNameFile);
    final occImg = MemoryImage(occFile);

    final Uint8List regularFont =
        File('$rootPath/LiberationSans-Regular.ttf').readAsBytesSync();

    final Uint8List boldFont =
        File('$rootPath/LiberationSans-Bold.ttf').readAsBytesSync();
    final Uint8List khmerFont = File("$rootPath/lmns7.ttf").readAsBytesSync();
    final Uint8List khmerBoldFont =
        File("$rootPath/LMNS4_0.TTF").readAsBytesSync();
    final Uint8List khmerFontTest =
        File("$rootPath/Kantumruy-Regular.ttf").readAsBytesSync();

    final regularData = regularFont.buffer.asByteData();
    final boldData = boldFont.buffer.asByteData();
    final khmerData = khmerFont.buffer.asByteData();
    final khmerBoldData = khmerBoldFont.buffer.asByteData();
    final khmerFontTestData = khmerFontTest.buffer.asByteData();
    final regularF = Font.ttf(regularData);
    final boldF = Font.ttf(boldData);
    final khmerF = Font.ttf(khmerData);
    final khmerBoldF = Font.ttf(khmerBoldData);
    final khmerTestF = Font.ttf(khmerFontTestData);
    var myFormat = DateFormat('dd /MM /yyyy');
    var dateNow = DateTime.now();
    final currentDate = myFormat.format(dateNow);
    RegExp regExpNum = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

    final Map<int, TableColumnWidth> columnWidthValKh = {
      0: FlexColumnWidth(0.6),
      1: FlexColumnWidth(0.925),
      2: FlexColumnWidth(0.925),
      3: FlexColumnWidth(1.4),
      4: FlexColumnWidth(0.825),
      5: FlexColumnWidth(0.9416),
      6: FlexColumnWidth(0.9416),
      7: FlexColumnWidth(0.9416)
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
            paymentModeStr = "RbcaMq??aM";
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
                "-",
                "-",
                "-"
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
              "-",
              "-",
              "-"
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
                "-",
                "-",
                "-"
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
              "-",
              "-",
              "-"
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
                "-",
                "-",
                "-"
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
                "-",
                "-",
                "-"
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
            "-",
            "-",
            "-"
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
            "${basicSANum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            "${getGSB().toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            "${(basicSANum + getGSB()).toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}"
          ]);
          i++;
        }
      }
      print("LP NAME LENGTH" + lpName.length.toString());

      return dynamicRow;
    }

    Document pdf = Document();
    pdf.addPage(MultiPage(
        footer: (Context context) => (lang == 'kh'
            ? Row(children: [
                Text("kalbriec??Te)aHBum<        ",
                    style: TextStyle(fontSize: 13, font: khmerBoldF)),
                Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Text(": $currentDate",
                        style: TextStyle(fontSize: 6.5, font: boldF))),
              ])
            : Text("Print Date               : $currentDate",
                style: TextStyle(font: boldF, fontSize: 8.25))),
        header: (Context context) =>
            (Row(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                            style: TextStyle(fontSize: 6.5, font: regularF))
                        : Expanded(
                            child: Stack(children: [
                            Text(
                                "Rk??mh???unFanar:ab;rgGayuCIvit hVtet LayhV_ GwsYruins_ exmbUDa mk",
                                style: TextStyle(fontSize: 12, font: khmerF)),
                            Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                    "GKar vD??n?? kaBItal; Can;TI18 GKar66 mhavifIRBHmun??IvgS sg??at;vt??P??M",
                                    style:
                                        TextStyle(fontSize: 12, font: khmerF))),
                            Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text("xN??dUneBj raCFanIP??MeBj",
                                    style:
                                        TextStyle(fontSize: 12, font: khmerF))),
                            Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("TUrs??B??",
                                          style: TextStyle(
                                              fontSize: 12, font: khmerF)),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.05),
                                        child: Text(" : (+855) 23 885 077/ 066",
                                            style: TextStyle(
                                                fontSize: 6.5, font: regularF)),
                                      ),
                                      Text(" TUrsar",
                                          style: TextStyle(
                                              fontSize: 12, font: khmerF)),
                                      Padding(
                                        padding: EdgeInsets.only(top: 3.7),
                                        child: Text(" : (+855) 23 986 922",
                                            style: TextStyle(
                                                fontSize: 6.5, font: regularF)),
                                      ),
                                    ])),
                            Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("sareGLicRt??nic",
                                          style: TextStyle(
                                              fontSize: 12, font: khmerF)),
                                      Padding(
                                        padding: EdgeInsets.only(top: 3.65),
                                        child: Text(
                                            " : info@fortelifeassurance.com",
                                            style: TextStyle(
                                                fontSize: 6.5, font: regularF)),
                                      ),
                                    ]))
                          ]))),
              ),
            ])),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        pageFormat: PdfPageFormat.a4,
        build: (Context context) => <Widget>[
              Wrap(children: [
                Container(
                    child: Expanded(
                        child: Column(children: [
                  SizedBox(height: lang != 'kh' ? 12.5 : 5),
                  lang != 'kh'
                      ? Text("SALES ILLUSTRATION",
                          style: TextStyle(
                              fontSize: 14.5,
                              font: boldF,
                              fontWeight: FontWeight.bold))
                      : Text("taragbg??ajGMBIplitpl",
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
                                              title: "eQ??aH",
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
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5,
                                                  bottom: 2.5,
                                                  top: 2.5),
                                              child: Container(
                                                  width: 122.5,
                                                  child: Text("Life Proposed",
                                                      style: TextStyle(
                                                          font: regularF,
                                                          fontSize: 8.25)))),

                                          SizedBox(
                                              width: 150,
                                              child: Center(
                                                  child: Text(lpName,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          font: regularF,
                                                          fontSize: 8.25)))),

                                          SizedBox(
                                              width: 60,
                                              child: Center(
                                                  child: Text(lpAge,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          font: regularF,
                                                          fontSize: 8.25)))),
                                          SizedBox(
                                              width: 150,
                                              child: Center(
                                                  child: Text(lpGender,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          font: regularF,
                                                          fontSize: 8.25)))),
                                          SizedBox(
                                              width: 55,
                                              child: Center(
                                                  child: Text(lpOccupation,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          font: regularF,
                                                          fontSize: 8.25)))),
                                          // PDFSubtitle(
                                          //     isKhmer: false,
                                          //     title: lpGender,
                                          //     font: regularF),
                                          // Padding(
                                          //   padding: EdgeInsets.only(right: 5),
                                          //   child: PDFSubtitle(
                                          //       isKhmer: false,
                                          //       title: lpOccupation,
                                          //       font: regularF),
                                          // )
                                        ]),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5,
                                                  bottom: 2.5,
                                                  top: 2.5),
                                              child: Container(
                                                  width: 122.5,
                                                  child: Text("Payor",
                                                      style: TextStyle(
                                                          font: regularF,
                                                          fontSize: 8.25)))),
                                          SizedBox(
                                              width: 150,
                                              child: Center(
                                                  child: Text(pName,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          font: regularF,
                                                          fontSize: 8.25)))),
                                          SizedBox(
                                              width: 60,
                                              child: Center(
                                                  child: Text(pAge,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          font: regularF,
                                                          fontSize: 8.25)))),
                                          SizedBox(
                                              width: 150,
                                              child: Center(
                                                  child: Text(pGender,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          font: regularF,
                                                          fontSize: 8.25)))),
                                          SizedBox(
                                              width: 55,
                                              child: Center(
                                                  child: Text(pOccupation,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          font: regularF,
                                                          fontSize: 8.25)))),
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
                                                          "G??kbg;buBVlaPFanar:ab;rg",
                                                          style: TextStyle(
                                                              font: khmerF,
                                                              fontSize: 16)))),
                                              SizedBox(width: 45),
                                              SizedBox(
                                                  width: 90,
                                                  child: Center(
                                                      child: Image(pNameImg,
                                                          height: 20,
                                                          fit: BoxFit.cover))),
                                              SizedBox(
                                                  width: 90,
                                                  child: Center(
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              top: 5.25,
                                                            ),
                                                            child: Text(pAge,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        8.25,
                                                                    font:
                                                                        regularF))),
                                                        Text("q??aM",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                font: khmerF)),
                                                      ]))),
                                              Center(
                                                child: PDFSubtitle(
                                                    isKhmer: true,
                                                    title: pGender == 'Male'
                                                        ? "Rb??s"
                                                        : "RsI",
                                                    font: khmerF),
                                              ),
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                  child: Center(
                                                      child: SizedBox(
                                                          width: 90,
                                                          child: Center(
                                                              child: Image(
                                                                  occImg,
                                                                  height: 20,
                                                                  fit: BoxFit
                                                                      .cover)))))
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
                                                      "G??kRt??v)anFanar:ab;rgGayuCIvit",
                                                      style: TextStyle(
                                                          font: khmerF,
                                                          fontSize: 16)))),
                                          SizedBox(width: 45),
                                          SizedBox(
                                              width: 90,
                                              child: Center(
                                                  child: Image(lpNameImg,
                                                      height: 20,
                                                      fit: BoxFit.cover))),
                                          SizedBox(
                                              width: 90,
                                              child: Center(
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 5.25,
                                                        ),
                                                        child: Text(lpAge,
                                                            style: TextStyle(
                                                                fontSize: 8.25,
                                                                font:
                                                                    regularF))),
                                                    Text("q??aM",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            font: khmerF)),
                                                  ]))),
                                          PDFSubtitle(
                                              isKhmer: true,
                                              title: lpGender == 'Male'
                                                  ? "Rb??s"
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
                                                        "cMnYnTwkR)ak;Rt??v)an",
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
                                                title: "kalkMNt;??nbN??",
                                                font: khmerBoldF),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10.5),
                                                child: PDFSubtitle(
                                                    isKhmer: true,
                                                    title: "sn??ar:ab;rg",
                                                    font: khmerBoldF))
                                          ]),
                                          Stack(children: [
                                            PDFSubtitle(
                                                isKhmer: true,
                                                title: "ry??eBlbg;buBVlaPFana",
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
                                                        Text("KeRmagmUld??an",
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
                                                        Stack(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            children: [
                                                              Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        "GayuCIvitsRmab;karsikSa-",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            font:
                                                                                khmerF)),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                5.25),
                                                                        child: Text(
                                                                            "18",
                                                                            style:
                                                                                TextStyle(fontSize: 8.25, font: regularF)))
                                                                  ])
                                                            ])
                                                      ]))),
                                          SizedBox(width: 22.75),
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
                                                    Text("dul??ar",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            font: khmerF)),
                                                  ])),
                                          SizedBox(
                                              width: 90,
                                              child: Center(
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 5.25,
                                                        ),
                                                        child: Text(policyTerm,
                                                            style: TextStyle(
                                                                fontSize: 8.25,
                                                                font:
                                                                    regularF))),
                                                    Text("q??aM",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            font: khmerF)),
                                                  ]))),
                                          SizedBox(
                                              width: 90,
                                              child: Center(
                                                  child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: 5.25,
                                                        ),
                                                        child: Text(policyTerm,
                                                            style: TextStyle(
                                                                fontSize: 8.25,
                                                                font:
                                                                    regularF))),
                                                    Text("q??aM",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            font: khmerF)),
                                                  ]))),
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
                                              width: 225.5,
                                              child: Text("Basic Plan : $title",
                                                  style: TextStyle(
                                                      font: regularF,
                                                      fontSize: 8.25))),
                                          SizedBox(width: 33.5),
                                          PDFSubtitle(
                                              isKhmer: false,
                                              title:
                                                  "USD ${getPremiumPayment(paymentMode)[1].toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                                              font: regularF)
                                        ]),
                                  )
                                : Stack(children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(left: 5),
                                              width: 214.5,
                                              child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("KeRmagmUld??an",
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
                                                    Stack(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        children: [
                                                          Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    "GayuCIvitsRmab;karsikSa-",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        font:
                                                                            khmerF)),
                                                                Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                5.25),
                                                                    child: Text(
                                                                        "18",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                8.25,
                                                                            font:
                                                                                regularF)))
                                                              ])
                                                        ])
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
                                                Text("dul??ar",
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
                                                width: 225.5,
                                                child: Text("Total Premium",
                                                    style: TextStyle(
                                                        font: boldF,
                                                        fontSize: 8.25)))),
                                        SizedBox(width: 33.5),
                                        PDFSubtitle(
                                            isKhmer: false,
                                            title:
                                                "USD ${getPremiumPayment(paymentMode)[1].toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                                            font: regularF)
                                      ])
                                : Stack(children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Container(
                                                  width: 214.5,
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
                                                    Text("dul??ar",
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
                                                    title: "RbcaMq??aM",
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
                                                      Text("dul??ar",
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
                                                      Text("dul??ar",
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
                                                      Text("dul??ar",
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
                                                      Text("dul??ar",
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
                                                  width: 45.65,
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
                                                width: 105.55,
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
                                                width: 62.25,
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
                                                              .start,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 4),
                                                            child: Column(
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
                                                                                TextAlign.center,
                                                                            style: TextStyle(font: boldF, fontSize: 8.25)),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(top: 10),
                                                                          child: Text(
                                                                              "Maturity Benefit",
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(font: boldF, fontSize: 8.25)),
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
                                                                ])),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Column(
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
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style: TextStyle(
                                                                              font: boldF,
                                                                              fontSize: 8.25)),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 10),
                                                                        child: Text(
                                                                            "Special Benefit",
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(font: boldF, fontSize: 8.25)),
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
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left:
                                                                        13.75),
                                                            child: Column(
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
                                                                                TextAlign.center,
                                                                            style: TextStyle(font: boldF, fontSize: 8.25)),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(top: 10),
                                                                          child: Text(
                                                                              "Benefit",
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(font: boldF, fontSize: 8.25)),
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
                                                                ]))
                                                      ])),
                                            ])
                                      ]),
                                ]),
                                Table.fromTextArray(
                                    headerAlignment: Alignment.topCenter,
                                    columnWidths: columnWidthValKh,
                                    headerHeight: 0,
                                    headers: [""],
                                    headerPadding: const EdgeInsets.all(0),
                                    cellHeight: 0.05,
                                    cellDecoration: (index, data, rowNum) {
                                      if (index == 1) {
                                        return BoxDecoration(
                                            border: TableBorder(
                                                left: BorderSide(width: 2)));
                                      } else if (index == 3) {
                                        return BoxDecoration(
                                            border: TableBorder(
                                                left: BorderSide(width: 2)));
                                      } else if (index == 4) {
                                        return BoxDecoration(
                                            border: TableBorder(
                                                left: BorderSide(width: 2)));
                                      } else if (index == 5) {
                                        return BoxDecoration(
                                            border: TableBorder(
                                                left: BorderSide(width: 2)));
                                      } else
                                        return BoxDecoration(
                                            border: Border.symmetric(
                                                horizontal: BorderSide(
                                                    color: PdfColors.white)));
                                    },
                                    cellPadding: EdgeInsets.only(
                                        top: 1.25,
                                        right: 2.5,
                                        left: 2.5,
                                        bottom: 1.25),
                                    cellStyle: TextStyle(
                                        font: regularF, fontSize: 7.6),
                                    cellAlignment: Alignment.topCenter,
                                    border: TableBorder(
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
                                                  width: 45.63,
                                                  height: 95,
                                                  child: Stack(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      children: [
                                                        Text("enAcugq??aM",
                                                            style: TextStyle(
                                                                font:
                                                                    khmerBoldF,
                                                                fontSize: 16)),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 12.5),
                                                            child: Text(
                                                                "bN??sn??a",
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
                                                width: 139.45,
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
                                                                    "??dul??ar??",
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
                                                                            1),
                                                                child: Text(
                                                                    "srubRbcaMq??aM",
                                                                    style: TextStyle(
                                                                        font:
                                                                            khmerBoldF,
                                                                        fontSize:
                                                                            16))),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 1),
                                                              child: Text(
                                                                  "srubbUkbg??r",
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
                                                width: 105.51,
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
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      "Gt??RbeyaCn_mrNPaB",
                                                                      style: TextStyle(
                                                                          font:
                                                                              khmerBoldF,
                                                                          fontSize:
                                                                              16)),
                                                                  Text(" ",
                                                                      style: TextStyle(
                                                                          font:
                                                                              regularF,
                                                                          fontSize:
                                                                              8.25)),
                                                                  Text(
                                                                      "nigBikarPaB",
                                                                      style: TextStyle(
                                                                          font:
                                                                              khmerBoldF,
                                                                          fontSize:
                                                                              16)),
                                                                ]),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            12.5),
                                                                child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          "TaMgRs??g",
                                                                          style: TextStyle(
                                                                              font: khmerBoldF,
                                                                              fontSize: 16)),
                                                                      Text(" ",
                                                                          style: TextStyle(
                                                                              font: regularF,
                                                                              fontSize: 8.25)),
                                                                      Text(
                                                                          "nigCaGci??Rn??y_??dul??ar??",
                                                                          style: TextStyle(
                                                                              font: khmerBoldF,
                                                                              fontSize: 16)),
                                                                    ])),
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
                                                width: 62.18,
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
                                                            Text("t??m??",
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
                                                      Text("??dul??ar??",
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
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 9),
                                                          child: Column(
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
                                                                          "Gt??RbeyaCn_dl;",
                                                                          style: TextStyle(
                                                                              font: khmerBoldF,
                                                                              fontSize: 16)),
                                                                      Padding(
                                                                          padding: EdgeInsets.only(
                                                                              top:
                                                                                  12.5),
                                                                          child: Text(
                                                                              "kalkMNt;Rt??v)an",
                                                                              style: TextStyle(font: khmerBoldF, fontSize: 16))),
                                                                      Padding(
                                                                          padding: EdgeInsets.only(
                                                                              top:
                                                                                  25),
                                                                          child: Text(
                                                                              "Fana",
                                                                              style: TextStyle(font: khmerBoldF, fontSize: 16))),
                                                                    ]),
                                                                Text("??dul??ar??",
                                                                    style: TextStyle(
                                                                        font:
                                                                            khmerBoldF,
                                                                        fontSize:
                                                                            16))
                                                              ]),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 26.5),
                                                          child: Column(
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
                                                                          "Gt??RbeyaCn_",
                                                                          style: TextStyle(
                                                                              font: khmerBoldF,
                                                                              fontSize: 16)),
                                                                      Padding(
                                                                          padding: EdgeInsets.only(
                                                                              top:
                                                                                  12.5),
                                                                          child: Text(
                                                                              "BiessRt??v)an",
                                                                              style: TextStyle(font: khmerBoldF, fontSize: 16))),
                                                                      Padding(
                                                                          padding: EdgeInsets.only(
                                                                              top:
                                                                                  25),
                                                                          child: Text(
                                                                              "Fana",
                                                                              style: TextStyle(font: khmerBoldF, fontSize: 16))),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 41),
                                                                        child: Image(
                                                                            header4,
                                                                            width:
                                                                                32.5,
                                                                            height:
                                                                                40,
                                                                            fit:
                                                                                BoxFit.contain),
                                                                      )
                                                                    ]),
                                                                Text("??dul??ar??",
                                                                    style: TextStyle(
                                                                        font:
                                                                            khmerBoldF,
                                                                        fontSize:
                                                                            16))
                                                              ]),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 27.25),
                                                          child: Column(
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
                                                                          "Gt??RbeyaCn_dl;",
                                                                          style: TextStyle(
                                                                              font: khmerBoldF,
                                                                              fontSize: 16)),
                                                                      Padding(
                                                                          padding: EdgeInsets.only(
                                                                              top:
                                                                                  12.5),
                                                                          child: Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Text("kalkMNt;bUk", style: TextStyle(font: khmerBoldF, fontSize: 16)),
                                                                                Text(" ", style: TextStyle(font: regularF, fontSize: 8.25)),
                                                                                Text("nig", style: TextStyle(font: khmerBoldF, fontSize: 16)),
                                                                              ])),
                                                                      Padding(
                                                                          padding: EdgeInsets.only(
                                                                              top:
                                                                                  25),
                                                                          child: Text(
                                                                              "Gt??RbeyaCn_",
                                                                              style: TextStyle(font: khmerBoldF, fontSize: 16))),
                                                                      Padding(
                                                                          padding: EdgeInsets.only(
                                                                              top:
                                                                                  37.5),
                                                                          child: Text(
                                                                              "Biess",
                                                                              style: TextStyle(font: khmerBoldF, fontSize: 16))),
                                                                    ]),
                                                                Text("??dul??ar??",
                                                                    style: TextStyle(
                                                                        font:
                                                                            khmerBoldF,
                                                                        fontSize:
                                                                            16))
                                                              ]),
                                                        )
                                                      ])),
                                            ])
                                      ]),
                                ]),
                                Table.fromTextArray(
                                    headerAlignment: Alignment.topCenter,
                                    columnWidths: columnWidthValKh,
                                    cellHeight: 0.05,
                                    headerHeight: 0,
                                    headers: [""],
                                    headerPadding: const EdgeInsets.all(0),
                                    cellDecoration: (index, data, rowNum) {
                                      if (index == 1) {
                                        return BoxDecoration(
                                            border: TableBorder(
                                                left: BorderSide(width: 2)));
                                      } else if (index == 3) {
                                        return BoxDecoration(
                                            border: TableBorder(
                                                left: BorderSide(width: 2)));
                                      } else if (index == 4) {
                                        return BoxDecoration(
                                            border: TableBorder(
                                                left: BorderSide(width: 2)));
                                      } else if (index == 5) {
                                        return BoxDecoration(
                                            border: TableBorder(
                                                left: BorderSide(width: 2)));
                                      } else
                                        return BoxDecoration(
                                            border: Border.symmetric(
                                                horizontal: BorderSide(
                                                    color: PdfColors.white)));
                                    },
                                    cellPadding: EdgeInsets.only(
                                        top: 1.25,
                                        right: 2.5,
                                        left: 2.5,
                                        bottom: 1.25),
                                    cellStyle: TextStyle(
                                        font: regularF, fontSize: 7.6),
                                    cellAlignment: Alignment.topCenter,
                                    border: TableBorder(
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
                                        "2.	The Guaranteed Special Benefit shall be equal to 2% of Basic Sum Assured multiplied by the Policy term for Payor with entry age below 50 years last" +
                                        "\n     birthday and 1% of Basic Sum Assured multiplied by the policy term for Payor age 50 years last birthday and above." +
                                        "\n" +
                                        "3.	The Guaranteed Maturity Benefit will be payable at the end of the policy term." +
                                        "\n" +
                                        "4. This policy will acquire a Cash Value after it has been in-force for a minimum of two (2) years" +
                                        "\n" +
                                        "5.	Upon the Life Assured attaining the age of 12, an Education Cash Allowance of USD 100 will be available to the policy owner." +
                                        "\n" +
                                        "6. Upon the death or total and permanent disablement (as defined in the policy) of the Payor and subject to the terms and conditions in the policy contract, \n    all premiums will be waived until the policy matures." +
                                        "\n" +
                                        "7. The above are for illustration purposes only. The benefits described herein are subject to all the terms and conditions contained in the policy contract." +
                                        "\n\n" +
                                        "Note: This Sales Illustration shall be expired 30 days after print date below.",
                                    style: TextStyle(
                                        fontSize: 8.25, font: regularF))),
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Stack(children: [
                              Text(
                                  "??k?? enHKWCaKeRmagFanar:ab;rgTayC??TanEdlminmankarcUlrYmEbgEckPaKlaPCamYyRk??mh???un Edlkarbg;buBVlaPFanar:ab;rgeTAtamkalkMNt;??nbN??sn??ar:ab;rg.",
                                  style: TextStyle(fontSize: 13, font: khmerF)),
                              Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            "??x?? Gt??RbeyaCn_BiessRt??v)anFana Rt??v)anKNnaedayykGRtakarR)ak; ",
                                            style: TextStyle(
                                                fontSize: 13, font: khmerF)),
                                        Padding(
                                            padding: EdgeInsets.only(top: 1.25),
                                            child: Text("2",
                                                style: TextStyle(
                                                    fontSize: 6.25,
                                                    font: regularF))),
                                        Text(
                                            "????nTwkR)ak;Fanar:ab;rg KuNnwgcMnYnq??aM??nkalkMNt;??nbN??sn??ar:ab;rg sRmab;G??kbg;buBVlaPFanar:ab;rgEdlmanGayuenAeBlcab;ep??ImFana",
                                            style: TextStyle(
                                                fontSize: 13, font: khmerF)),
                                      ])),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 20, left: 13.75),
                                  child: Row(children: [
                                    Text("eRkam ",
                                        style: TextStyle(
                                            fontSize: 13, font: khmerF)),
                                    Padding(
                                        padding: EdgeInsets.only(top: 1.25),
                                        child: Text("50",
                                            style: TextStyle(
                                                fontSize: 6.25,
                                                font: regularF))),
                                    Text(
                                        "q??aMKitRtwm??f??xYbkMeNItcugeRkayedayELksRmab;G??kbg;buBVlaPFanar:ab;rgEdlmanGayuenAeBlcab;ep??ImFanacab;BI ",
                                        style: TextStyle(
                                            fontSize: 13, font: khmerF)),
                                    Padding(
                                        padding: EdgeInsets.only(top: 1.25),
                                        child: Text("50",
                                            style: TextStyle(
                                                fontSize: 6.25,
                                                font: regularF))),
                                    Text(
                                        "q??aMeLIgeTAKitRtwm??f??xYbkMeNItcugeRkayGRtakarR)ak;",
                                        style: TextStyle(
                                            fontSize: 13, font: khmerF)),
                                    Padding(
                                        padding: EdgeInsets.only(top: 1.25),
                                        child: Text(" 1",
                                            style: TextStyle(
                                                fontSize: 6.25,
                                                font: regularF))),
                                    Text("????nTwkR)ak;Fanar:ab;rgKuNnwg",
                                        style: TextStyle(
                                            fontSize: 13, font: khmerF)),
                                  ])),
                              Padding(
                                padding: EdgeInsets.only(top: 30, left: 13.75),
                                child: Text(
                                    "cMnYnq??aM??nkalkMNt;??nbN??sn??ar:ab;rgnwgRt??v)anykmkKNna. Gt??RbeyaCn_BiessRt??v)anFananwgRt??vTUTat;EteBldl;kalkMNt;??nbN??sn??ar:ab;rgb:ueN??aH.",
                                    style:
                                        TextStyle(fontSize: 13, font: khmerF)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Text(
                                    "??K?? Gt??RbeyaCn_dl;kalkMNt;Rt??v)anFanaEdlmant??m??es??IK??anwgTwkR)ak;Rt??v)anFanar:ab;rgsrubnwgRt??v)anTUTat;enAcugbBa??b;??nkalkMNt;??nbN??sn??ar:ab;rg.",
                                    style:
                                        TextStyle(fontSize: 13, font: khmerF)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 50),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("??X??",
                                          style: TextStyle(
                                              fontSize: 13, font: khmerF)),
                                      SizedBox(width: 2.5),
                                      Text(
                                          "bN??sn??ar:ab;rgenHnwgTTYl)annUvt??m??sac;R)ak; bn??ab;BIbN??sn??ar:ab;rgenHRt??v)ancUlCaFrmank????gry??eBly:agtic ",
                                          style: TextStyle(
                                              fontSize: 13, font: khmerF)),
                                      Padding(
                                          padding: EdgeInsets.only(top: 1.25),
                                          child: Text("2",
                                              style: TextStyle(
                                                  fontSize: 6.25,
                                                  font: regularF))),
                                      Text("q??aM.",
                                          style: TextStyle(
                                              fontSize: 13, font: khmerF)),
                                    ]),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 60),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("??g?? enAeBlkUnmanGayu ",
                                          style: TextStyle(
                                              fontSize: 13, font: khmerF)),
                                      Padding(
                                          padding: EdgeInsets.only(top: 1.25),
                                          child: Text("12",
                                              style: TextStyle(
                                                  fontSize: 6.25,
                                                  font: regularF))),
                                      Text(
                                          "q??aM R)ak;elIkTwkcit??sRmab;karsikSacMnYn ",
                                          style: TextStyle(
                                              fontSize: 13, font: khmerF)),
                                      Padding(
                                          padding: EdgeInsets.only(top: 1.25),
                                          child: Text("100",
                                              style: TextStyle(
                                                  fontSize: 6.25,
                                                  font: regularF))),
                                      Text(
                                          "dul??arnwgRt??v)anp??l;CUneTAm??as;bN??sn??ar:ab;rg. m??as;bN??sn??ar:ab;rgnwgmanCeRmIsk????gkardkR)ak; b??epJIR)ak;TukedIm,Ibg??rR)ak;cMnYn ",
                                          style: TextStyle(
                                              fontSize: 13, font: khmerF)),
                                      Padding(
                                          padding: EdgeInsets.only(top: 1.25),
                                          child: Text("100",
                                              style: TextStyle(
                                                  fontSize: 6.25,
                                                  font: regularF))),
                                      Text("dul??ar",
                                          style: TextStyle(
                                              fontSize: 13, font: khmerF)),
                                    ]),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 70, left: 13.75),
                                child: Text(
                                    "bUkbBa????lCamYyt??m??TwkR)ak;Edlman nigGt??RbeyaCn_dl;kalkMNt;EdlRt??v)anFanaCamYynwgRk??mh???un.",
                                    style:
                                        TextStyle(fontSize: 13, font: khmerF)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 80),
                                child: Text(
                                    "??c?? k????gkrNIEdlG??kbg;buBVlaPFanar:ab;rgTTYlmrNPaB b??BikarPaBTaMgRs??g nigCaGci??Rn??y_buBVlaPFanar:ab;rgTaMgGs;naeBlGnaKtGnuelamtambN??sn??ar:ab;rgenHnwgminRt??v)antRm??v[bg;bn??eToteLIy.",
                                    style:
                                        TextStyle(fontSize: 13, font: khmerF)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 90),
                                child: Text(
                                    "??q?? xagelIenHCakarbg??ajGMBIplitplFanar:ab;rgEtb:ueN??aH. Gt??RbeyaCn_Edl)anBiBN???naenATIenH KWRt??vGnuelamtam x niglk??xN??TaMgGs;EdlmanEcgenAk????gkic??sn??ar:ab;rg.",
                                    style:
                                        TextStyle(fontSize: 13, font: khmerF)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 105),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          "sm??al;?? taragsm??al;bg??ajBIplitplenHnwgRt??vGs;suBlPaBry??eBl",
                                          style: TextStyle(
                                              fontSize: 13, font: khmerF)),
                                      Padding(
                                          padding: EdgeInsets.only(top: 1.25),
                                          child: Text(" 30",
                                              style: TextStyle(
                                                  fontSize: 6.25,
                                                  font: regularF))),
                                      Text(
                                          "??f??eRkaykalbriec??Te)aHBum<xageRkam.",
                                          style: TextStyle(
                                              fontSize: 13, font: khmerF)),
                                    ]),
                              ),
                            ]),
                          )
                  ]))
                ]))),
              ])
            ]));
    return pdf;
  }
}
