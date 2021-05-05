import 'dart:typed_data';

import 'package:forte_life/widgets/pdf/pdf_subtitle.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';

class PDFWidget {
  Document createPDF(
      String title,
      bool addRider,
      bool differentP,
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
      String premiumRider,
      String riderSA,
      bool isOnPolicy,
      String lang,
      String rootPath) {
    //Final variables
    final file = File("$rootPath/logo.png").readAsBytesSync();
    final file4 = File("$rootPath/money.png").readAsBytesSync();
    final file1 = File("$rootPath/piggybank.png").readAsBytesSync();
    final file3 = File("$rootPath/stats.png").readAsBytesSync();
    final file2 = File("$rootPath/umbrella.png").readAsBytesSync();
    final pNameFile = File("$rootPath/wordPro.png").readAsBytesSync();
    final lPNameFile = File("$rootPath/wordLPPro.png").readAsBytesSync();
    final occFile = File("$rootPath/wordOccPro.png").readAsBytesSync();
    final lOccFile = File("$rootPath/wordlOccPro.png").readAsBytesSync();

    final logo = MemoryImage(file);
    final header1 = MemoryImage(file1);
    final header2 = MemoryImage(file2);
    final header3 = MemoryImage(file3);
    final header4 = MemoryImage(file4);
    final pNameImg = MemoryImage(pNameFile);
    final lpNameImg = MemoryImage(lPNameFile);
    final occImg = MemoryImage(occFile);
    final lOccImg = MemoryImage(lOccFile);

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
    final Map<int, TableColumnWidth> columnWidthVal = {
      0: FlexColumnWidth(0.403),
      1: FlexColumnWidth(0.9),
      2: FlexColumnWidth(0.9),
      3: FlexColumnWidth(0.9),
      4: FlexColumnWidth(0.9),
      5: FlexColumnWidth(0.825),
      6: FlexColumnWidth(2.772),
    };

    //Doubles with no previous values
    double accumulatedPremium = 0;
    double accumulatedPremiumNoRider = 0;
    double allCauses = 0;
    double allAccidents = 0;
    double cashValue = 0;
    double totalPremiumNum = 0;
    //

    //Convert String to Double for ease of use
    double basicSANum = double.parse(basicSA);
    double premiumNum = double.parse(premium);
    double yearlyNum = double.parse(premium);
    //

    //Doubles with conditions
    double riderSANum = addRider == true ? double.parse(riderSA) : 0;
    double premiumRiderNum = addRider == true ? double.parse(premiumRider) : 0;
    //

    // Total premium
    double totalPremium = premiumNum + premiumRiderNum;
    //

    // Round all the doubles to a .00 decimal format
    double halfPNum = premiumNum * 0.5178;
    double quarterlyPNum = premiumNum * 0.2635;
    double monthlyPNum = premiumNum * 0.0888;
    double halfPNumR = (premiumNum + premiumRiderNum) * 0.5178;
    double quarterlyPNumR = (premiumNum + premiumRiderNum) * 0.2635;
    double monthlyPNumR = (premiumNum + premiumRiderNum) * 0.0888;
    String halfP = addRider == true
        ? halfPNumR
            .toStringAsFixed(2)
            .replaceAllMapped(regExpNum, (Match m) => '${m[1]},')
        : halfPNum
            .toStringAsFixed(2)
            .replaceAllMapped(regExpNum, (Match m) => '${m[1]},');
    String quarterlyP = addRider == true
        ? quarterlyPNumR
            .toStringAsFixed(2)
            .replaceAllMapped(regExpNum, (Match m) => '${m[1]},')
        : quarterlyPNum
            .toStringAsFixed(2)
            .replaceAllMapped(regExpNum, (Match m) => '${m[1]},');
    String monthlyP = addRider == true
        ? monthlyPNumR
            .toStringAsFixed(2)
            .replaceAllMapped(regExpNum, (Match m) => '${m[1]},')
        : monthlyPNum
            .toStringAsFixed(2)
            .replaceAllMapped(regExpNum, (Match m) => '${m[1]},');
    String riderSAStr = riderSANum
        .toStringAsFixed(2)
        .replaceAllMapped(regExpNum, (Match m) => '${m[1]},');
    String totalPremiumStr = totalPremium
        .toStringAsFixed(2)
        .replaceAllMapped(regExpNum, (Match m) => '${m[1]},');
    String cashValueStr = cashValue
        .toStringAsFixed(2)
        .replaceAllMapped(regExpNum, (Match m) => '${m[1]},');
    //

    double getGSB() {
      if (int.parse(lpAge) < 50) {
        return (basicSANum * (double.parse(policyTerm) * 2) / 100);
      } else {
        return (basicSANum * double.parse(policyTerm) / 100);
      }
    }

    bool getPdfStatusKh() {
      if (lang == 'kh') {
        if (int.parse(policyTerm) > 25)
          return true;
        else
          return false;
      } else
        return false;
    }

    List getPremiumPayment(String paymentMode) {
      double premiumPayment = 0;
      double truePremium = 0;
      double premiumWithR = 0;
      double premiumRiderPM = 0;
      String paymentModeStr;
      switch (paymentMode) {
        case "Yearly":
          {
            truePremium = yearlyNum;
            premiumPayment = yearlyNum;
            premiumWithR = totalPremium;
            premiumRiderPM = premiumRiderNum;
            paymentModeStr = "RbcaMqÒaM";
            break;
          }
        case "Half-yearly":
          {
            truePremium = halfPNum;
            premiumPayment = halfPNum * 2;
            premiumWithR = halfPNumR;
            premiumRiderPM = premiumRiderNum * 0.5178;
            paymentModeStr = "RbcaMqmas";
            break;
          }
        case "Quarterly":
          {
            truePremium = quarterlyPNum;
            premiumPayment = quarterlyPNum * 4;
            premiumWithR = quarterlyPNumR;
            premiumRiderPM = premiumRiderNum * 0.2635;
            paymentModeStr = "RbcaMRtImas";
            break;
          }
        case "Monthly":
          {
            truePremium = monthlyPNum;
            premiumPayment = monthlyPNum * 12;
            premiumWithR = monthlyPNumR;
            premiumRiderPM = premiumRiderNum * 0.0888;
            paymentModeStr = "RbcaMEx";
            break;
          }
      }
      double totalPremiumDisplay = truePremium + premiumRiderNum;
      List premiumAndSale = [
        premiumPayment,
        totalPremiumDisplay,
        truePremium,
        premiumWithR,
        premiumRiderPM,
        paymentModeStr
      ];

      return premiumAndSale;
    }

    List<List<dynamic>> getDynamicRow(
        int policyYear, int age, String paymentMode) {
      List<List<dynamic>> dynamicRow = List();
      int i = 1;
      double cashValPercentage = 0;
      premiumNum = getPremiumPayment(paymentMode)[0];
      totalPremiumNum = (premiumNum + premiumRiderNum);
      accumulatedPremiumNoRider += yearlyNum;
      accumulatedPremium += totalPremiumNum;
      if (isOnPolicy == false) {
        age += 1;
      }
      //All causes and accidents, List initialization
      switch (age) {
        case 1:
          {
            allCauses = (basicSANum * 0.4) + riderSANum;
            allAccidents = (basicSANum * 0.8) + riderSANum;
            dynamicRow = [
              [
                "$i",
                "${totalPremiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allAccidents.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "-",
                "    -                                -                              -"
              ],
            ];
            i++;
            allCauses = (basicSANum * 0.6) + riderSANum;
            allAccidents = (basicSANum * 1.2) + riderSANum;
            accumulatedPremiumNoRider += yearlyNum;
            accumulatedPremium += totalPremiumNum;
            dynamicRow.add([
              "$i",
              "${totalPremiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "${allAccidents.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "-",
              "    -                                -                              -"
            ]);
            allCauses = (basicSANum * 0.8) + riderSANum;
            allAccidents = (basicSANum * 1.2) + riderSANum;
            break;
          }
        case 2:
          {
            allCauses = (basicSANum * 0.6) + riderSANum;
            allAccidents = (basicSANum * 1.2) + riderSANum;
            dynamicRow = [
              [
                "$i",
                "${totalPremiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allAccidents.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "-",
                "    -                                -                              -"
              ],
            ];
            i++;
            allCauses = (basicSANum * 0.8) + riderSANum;
            allAccidents = (basicSANum * 1.6) + riderSANum;
            accumulatedPremiumNoRider += yearlyNum;
            accumulatedPremium += totalPremiumNum;
            dynamicRow.add([
              "$i",
              "${totalPremiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "${allAccidents.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "-",
              "    -                                -                              -"
            ]);
            allCauses = basicSANum + riderSANum;
            allAccidents = (basicSANum * 2) + riderSANum;
            break;
          }
        case 3:
          {
            allCauses = (basicSANum * 0.8) + riderSANum;
            allAccidents = (basicSANum * 1.6) + riderSANum;
            accumulatedPremiumNoRider += yearlyNum;
            dynamicRow = [
              [
                "$i",
                "${totalPremiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allAccidents.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "-",
                "    -                                -                              -"
              ],
            ];
            allCauses = basicSANum + riderSANum;
            allAccidents = (basicSANum * 2) + riderSANum;
            break;
          }

        default:
          {
            allCauses = basicSANum + riderSANum;
            allAccidents = (basicSANum * 2) + riderSANum;
            dynamicRow = [
              [
                "$i",
                "${totalPremiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allAccidents.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "-",
                "    -                                -                              -"
              ]
            ];
            break;
          }
      }
      //
      i++;
      while (i <= policyYear) {
        totalPremiumNum = (premiumNum + premiumRiderNum);
        accumulatedPremium += totalPremiumNum;
        accumulatedPremiumNoRider += yearlyNum;
        if (i >= 3) {
          if (i == 4) {
            allCauses = basicSANum + riderSANum;
            allAccidents = (basicSANum * 2) + riderSANum;
          }
          if (i <= 16) {
            if (i <= 12)
              cashValPercentage += 0.05;
            else
              cashValPercentage += 0.1;
          }
          cashValue = accumulatedPremiumNoRider * cashValPercentage;
          cashValueStr = cashValue
              .toStringAsFixed(2)
              .replaceAllMapped(regExpNum, (Match m) => '${m[1]},');
        } else
          cashValueStr = "-";
        if (i < policyYear) {
          dynamicRow.add([
            "$i",
            "${totalPremiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            "${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            "${allAccidents.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            cashValueStr,
            "    -                                -                              -"
          ]);
          i++;
        } else {
          dynamicRow.add([
            "$i",
            "${totalPremiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            "${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            "${allAccidents.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            cashValue
                .round()
                .toStringAsFixed(2)
                .replaceAllMapped(regExpNum, (Match m) => '${m[1]},'),
            (premium.length > 6)
                ? "${basicSANum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}          ${getGSB().toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}          ${(basicSANum + getGSB()).toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}"
                : "  ${basicSANum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}                ${getGSB().toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}                  ${(basicSANum + getGSB()).toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}"
          ]);
          i++;
        }
      }

      return dynamicRow;
    }

    Document pdf = Document();
    pdf.addPage(MultiPage(
        footer: (Context context) => (lang == 'kh'
            ? Row(children: [
                Text("kalbriecäTe)aHBum<        ",
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
              Flexible(
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
                              "Rkúmh‘unFanar:ab;rgGayuCIvit hVtet LayhV_ GwsYruins_ exmbUDa mk",
                              style: TextStyle(fontSize: 12, font: khmerF)),
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                  "GKar vDÆn³ kaBItal; Can;TI18 GKar66 mhavifIRBHmunñIvgS sgáat;vtþPñM",
                                  style:
                                      TextStyle(fontSize: 12, font: khmerF))),
                          Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text("xNÐdUneBj raCFanIPñMeBj",
                                  style:
                                      TextStyle(fontSize: 12, font: khmerF))),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("TUrs½BÞ",
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("sareGLicRtÚnic",
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
            ])),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        pageFormat: PdfPageFormat.a4,
        build: (Context context) => [
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
                                            padding: EdgeInsets.only(left: 40),
                                            child: Container(width: 100),
                                          ),
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
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 2.5, bottom: 2.5),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                child: Container(
                                                    width: 100,
                                                    child: Text("Life Proposed",
                                                        style: TextStyle(
                                                            font: regularF,
                                                            fontSize: 8.25)))),
                                            SizedBox(width: 20.5),
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
                                              padding:
                                                  EdgeInsets.only(right: 5),
                                              child: PDFSubtitle(
                                                  isKhmer: false,
                                                  title: lpOccupation,
                                                  font: regularF),
                                            )
                                          ]),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 2.5),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 5),
                                                  child: Container(
                                                      width: 100,
                                                      child: Text("Proposer",
                                                          style: TextStyle(
                                                              font: regularF,
                                                              fontSize:
                                                                  8.25)))),
                                              SizedBox(width: 20.5),
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
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                  child: PDFSubtitle(
                                                      isKhmer: false,
                                                      title: pOccupation,
                                                      font: regularF)),
                                            ]))
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
                                                          "GñkesñIsuMFanar:ab;rg",
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
                                                        Text("qñaM",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                font: khmerF)),
                                                      ]))),
                                              PDFSubtitle(
                                                  isKhmer: true,
                                                  title: pGender == 'Male'
                                                      ? "Rbús"
                                                      : "RsI",
                                                  font: khmerF),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 5),
                                                child: Center(
                                                    child: SizedBox(
                                                        width: 90,
                                                        child: Center(
                                                            child: Image(occImg,
                                                                height: 20,
                                                                fit: BoxFit
                                                                    .cover)))),
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
                                                    Text("qñaM",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            font: khmerF)),
                                                  ]))),
                                          PDFSubtitle(
                                              isKhmer: true,
                                              title: lpGender == 'Male'
                                                  ? "Rbús"
                                                  : "RsI",
                                              font: khmerF),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(right: 5),
                                              child: Center(
                                                  child: SizedBox(
                                                      width: 90,
                                                      child: Center(
                                                          child: Image(lOccImg,
                                                              height: 20,
                                                              fit: BoxFit
                                                                  .cover)))))
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
                                                left: 40,
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
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5,
                                                      top: 2.5,
                                                      bottom: 2.5),
                                                  child: SizedBox(
                                                      width: 150,
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                "Basic Plan  : $title",
                                                                style: TextStyle(
                                                                    font:
                                                                        regularF,
                                                                    fontSize:
                                                                        8.25)),
                                                            addRider == true
                                                                ? Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                2.5),
                                                                    child: Text(
                                                                        "Rider          : $title" +
                                                                            " Plus",
                                                                        style: TextStyle(
                                                                            font:
                                                                                regularF,
                                                                            fontSize:
                                                                                8.25)))
                                                                : SizedBox(
                                                                    height: 0)
                                                          ]))),
                                              Column(children: [
                                                PDFSubtitle(
                                                    isKhmer: false,
                                                    title:
                                                        "USD ${basicSANum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                                                    font: regularF),
                                                addRider == true
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 2.5),
                                                        child: PDFSubtitle(
                                                            isKhmer: false,
                                                            title:
                                                                "USD $riderSAStr",
                                                            font: regularF))
                                                    : SizedBox(height: 0)
                                              ]),
                                              SizedBox(width: 16.25),
                                              Column(children: [
                                                PDFSubtitle(
                                                    isKhmer: false,
                                                    title: policyTerm,
                                                    font: regularF),
                                                addRider == true
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 2.5),
                                                        child: PDFSubtitle(
                                                            isKhmer: false,
                                                            title: policyTerm,
                                                            font: regularF))
                                                    : SizedBox(height: 0)
                                              ]),
                                              SizedBox(width: 15.25),
                                              Column(children: [
                                                PDFSubtitle(
                                                    isKhmer: false,
                                                    title: policyTerm,
                                                    font: regularF),
                                                addRider == true
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 2.5),
                                                        child: PDFSubtitle(
                                                            isKhmer: false,
                                                            title: policyTerm,
                                                            font: regularF))
                                                    : SizedBox(height: 0)
                                              ]),
                                            ]),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(right: 3.5),
                                            child: PDFSubtitle(
                                                isKhmer: false,
                                                title: paymentMode,
                                                font: regularF))
                                      ])
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 5),
                                                  child: SizedBox(
                                                      width: 165.75,
                                                      child: Stack(children: [
                                                        Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "KeRmagmUldæan",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      font:
                                                                          khmerF)),
                                                              Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              4.8),
                                                                  child: Text(
                                                                      " : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              8.25,
                                                                          font:
                                                                              regularF))),
                                                              Text(
                                                                  "GayuCIvitelIKeRmagKaMBar",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      font:
                                                                          khmerF))
                                                            ]),
                                                        addRider == true
                                                            ? Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            14.5),
                                                                child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                          "plitplbEnßm",
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              font: khmerF)),
                                                                      Padding(
                                                                          padding: EdgeInsets.only(
                                                                              top:
                                                                                  4.8),
                                                                          child: Text(
                                                                              " : ",
                                                                              style: TextStyle(fontSize: 8.25, font: regularF))),
                                                                      Text(
                                                                          "GayuCIvitmankalkMNt;",
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              font: khmerF))
                                                                    ]))
                                                            : SizedBox(
                                                                height: 0)
                                                      ]))),
                                              Stack(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  children: [
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
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            5.25),
                                                                child: Text(
                                                                    "${basicSANum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')} ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            8.25,
                                                                        font:
                                                                            regularF))),
                                                            Text("duløar",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    font:
                                                                        khmerF)),
                                                          ])),
                                                    ),
                                                    addRider == true
                                                        ? Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 14.5),
                                                            child: SizedBox(
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
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                5.25),
                                                                        child: Text(
                                                                            "$riderSAStr ",
                                                                            style:
                                                                                TextStyle(fontSize: 8.25, font: regularF))),
                                                                    Text(
                                                                        "duløar",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            font:
                                                                                khmerF)),
                                                                  ])),
                                                            ),
                                                          )
                                                        : SizedBox(height: 0)
                                                  ]),
                                              SizedBox(width: 10.25),
                                              Stack(children: [
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
                                                                  EdgeInsets
                                                                      .only(
                                                                top: 5.25,
                                                              ),
                                                              child: Text(
                                                                  policyTerm,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          8.25,
                                                                      font:
                                                                          regularF))),
                                                          Text("qñaM",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  font:
                                                                      khmerF)),
                                                        ]))),
                                                addRider == true
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 14.5),
                                                        child: SizedBox(
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
                                                                          EdgeInsets
                                                                              .only(
                                                                        top:
                                                                            5.25,
                                                                      ),
                                                                      child: Text(
                                                                          policyTerm,
                                                                          style: TextStyle(
                                                                              fontSize: 8.25,
                                                                              font: regularF))),
                                                                  Text("qñaM",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          font:
                                                                              khmerF)),
                                                                ]))),
                                                      )
                                                    : SizedBox(height: 0)
                                              ]),
                                              SizedBox(width: 10.25),
                                              Stack(children: [
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
                                                                  EdgeInsets
                                                                      .only(
                                                                top: 5.25,
                                                              ),
                                                              child: Text(
                                                                  policyTerm,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          8.25,
                                                                      font:
                                                                          regularF))),
                                                          Text("qñaM",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  font:
                                                                      khmerF)),
                                                        ]))),
                                                addRider == true
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 14.5),
                                                        child: SizedBox(
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
                                                                          EdgeInsets
                                                                              .only(
                                                                        top:
                                                                            5.25,
                                                                      ),
                                                                      child: Text(
                                                                          policyTerm,
                                                                          style: TextStyle(
                                                                              fontSize: 8.25,
                                                                              font: regularF))),
                                                                  Text("qñaM",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          font:
                                                                              khmerF)),
                                                                ]))),
                                                      )
                                                    : SizedBox(height: 0)
                                              ]),
                                            ]),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(right: 3.5),
                                            child: PDFSubtitle(
                                                isKhmer: true,
                                                title: getPremiumPayment(
                                                    paymentMode)[5],
                                                font: khmerF))
                                      ]),
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
                                        left: 5, bottom: 2.5, top: 2.5),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    width: 200,
                                                    child: Text(
                                                        "Basic Plan  : $title",
                                                        style: TextStyle(
                                                            font: regularF,
                                                            fontSize: 8.25))),
                                                addRider == true
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            top: 2.5),
                                                        width: 200,
                                                        child: Text(
                                                            "Rider          : $title" +
                                                                " Plus",
                                                            style: TextStyle(
                                                                font: regularF,
                                                                fontSize:
                                                                    8.25)))
                                                    : SizedBox(height: 0)
                                              ]),
                                          SizedBox(width: 30),
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                PDFSubtitle(
                                                    isKhmer: false,
                                                    title:
                                                        "USD ${getPremiumPayment(paymentMode)[2].toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                                                    font: regularF),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 2.5),
                                                    child: PDFSubtitle(
                                                        isKhmer: false,
                                                        title: addRider == true
                                                            ? "USD ${getPremiumPayment(paymentMode)[4].toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}"
                                                            : "",
                                                        font: regularF)),
                                              ])
                                        ]),
                                  )
                                : Row(children: [
                                    Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: 268,
                                                  child: Stack(children: [
                                                    Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text("KeRmagmUldæan",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  font:
                                                                      khmerF)),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 4.8),
                                                              child: Text(" : ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          8.25,
                                                                      font:
                                                                          regularF))),
                                                          Text(
                                                              "GayuCIvitelIKeRmagKaMBar",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  font: khmerF))
                                                        ]),
                                                    addRider == true
                                                        ? Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 14.5),
                                                            child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      "plitplbEnßm",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          font:
                                                                              khmerF)),
                                                                  Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top:
                                                                              4.8),
                                                                      child: Text(
                                                                          " : ",
                                                                          style: TextStyle(
                                                                              fontSize: 8.25,
                                                                              font: regularF))),
                                                                  Text(
                                                                      "GayuCIvitmankalkMNt;",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          font:
                                                                              khmerF))
                                                                ]))
                                                        : SizedBox(height: 0)
                                                  ])),
                                              Stack(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  children: [
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
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            5.25),
                                                                child: Text(
                                                                    "${getPremiumPayment(paymentMode)[2].toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')} ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            8.25,
                                                                        font:
                                                                            regularF))),
                                                            Text("duløar",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    font:
                                                                        khmerF)),
                                                          ])),
                                                    ),
                                                    addRider == true
                                                        ? Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 14.5),
                                                            child: SizedBox(
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
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                5.25),
                                                                        child: Text(
                                                                            "${getPremiumPayment(paymentMode)[4].toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')} ",
                                                                            style:
                                                                                TextStyle(fontSize: 8.25, font: regularF))),
                                                                    Text(
                                                                        "duløar",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            font:
                                                                                khmerF)),
                                                                  ])),
                                                            ),
                                                          )
                                                        : SizedBox(height: 0)
                                                  ]),
                                            ]))
                                  ]),
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
                                                width: 180,
                                                child: Text("Total Premium",
                                                    style: TextStyle(
                                                        font: boldF,
                                                        fontSize: 8.25)))),
                                        Padding(
                                          padding: EdgeInsets.only(left: 50),
                                          child: PDFSubtitle(
                                              isKhmer: false,
                                              title:
                                                  "USD ${getPremiumPayment(paymentMode)[3].toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
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
                                                  width: 287.25,
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
                                          SizedBox(
                                              width: 90,
                                              child: Center(
                                                  child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5.25),
                                                        child: Text(
                                                            "${getPremiumPayment(paymentMode)[3].toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')} ",
                                                            style: TextStyle(
                                                                fontSize: 8.25,
                                                                font:
                                                                    regularF))),
                                                    Text("duløar",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            font: khmerF)),
                                                  ])))
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
                                                title: "USD $totalPremiumStr")
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
                                                              "$totalPremiumStr ",
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
                    SizedBox(height: 6.5),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Table(children: [
                            lang == 'kh'
                                ? TableRow(
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
                                                  width: 30,
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
                                                width: 133.9,
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
                                                                            0.5),
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
                                                                      left:
                                                                          0.5),
                                                              child: Text(
                                                                  "srubbUkbgÁr",
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
                                                width: 133.8,
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
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Text("RKb;mUlehtu",
                                                                style: TextStyle(
                                                                    font:
                                                                        khmerBoldF,
                                                                    fontSize:
                                                                        16)),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 3),
                                                              child: Text(
                                                                  "eRKaHfñak;",
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
                                                width: 61.4,
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
                                      ])
                                : TableRow(
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
                                                  width: 30,
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
                                                width: 133.9,
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
                                                width: 133.8,
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
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Text("All Causes",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    font: boldF,
                                                                    fontSize:
                                                                        8.25)),
                                                            Text("Accidents",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    font: boldF,
                                                                    fontSize:
                                                                        8.25)),
                                                          ])
                                                    ]),
                                              ),
                                              Container(
                                                height: 95,
                                                width: 61.4,
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
                              columnWidths: columnWidthVal,
                              headerAlignment: Alignment.center,
                              cellPadding: EdgeInsets.only(
                                  top: 1.25,
                                  right: 2.5,
                                  left: 2.5,
                                  bottom: 1.25),
                              headerHeight: 0.05,
                              cellHeight: 0.05,
                              headerPadding: const EdgeInsets.only(
                                  top: 3.5,
                                  right: 2.5,
                                  left: 2.5,
                                  bottom: 1.25),
                              headerStyle:
                                  TextStyle(font: regularF, fontSize: 7.6),
                              cellStyle:
                                  TextStyle(font: regularF, fontSize: 7.6),
                              cellAlignment: Alignment.topCenter,
                              border: TableBorder(
                                  verticalInside: BorderSide(),
                                  top: BorderSide(),
                                  bottom: BorderSide(),
                                  left: BorderSide(),
                                  right: BorderSide()),
                              context: context,
                              data: getDynamicRow(int.parse(policyTerm),
                                  int.parse(lpAge), paymentMode)),
                        ]),
                    lang != 'kh'
                        ? Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Flexible(
                                child: Text(
                                    "1.	This is a Non-participating Endowment plan with premium payables throughout the term of the Policy." +
                                        "\n" +
                                        "2.	The Guaranteed Special Benefit shall be equal to 2% of Basic Sum Assured multiplied by the Policy term with entry age below 50 years last birthday and \n    1% of Basic Sum Assured multiplied by the policy term with age 50 years last birthday and above. The Guaranteed Special Benefit shall only be \n    available upon maturity of the policy" +
                                        "\n" +
                                        "3.	This Policy will acquire a Cash Value after it has been in-force for a minimum of two years." +
                                        "\n" +
                                        "4. The above is for illustration purposes only. The benefits described herein are subject to all terms and conditions contained in the Policy contract."
                                            "\n" +
                                        "5.	Pays the earlier of either Death due to All Causes, TPD due to All Causes, Death due to Accident or TPD due to Accident." +
                                        "\n\n" +
                                        "Note: This Sales Illustration shall be expired 30 days after print date below.",
                                    style: TextStyle(
                                        fontSize: 8.25, font: regularF))),
                          )
                        : (int.parse(policyTerm) <= 30)
                            ? (int.parse(policyTerm) < 30)
                                ? Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Stack(children: [
                                      Text(
                                          "¬k¦ enHKWCaKeRmagFanar:ab;rgTayC¢TanEdlminmankarcUlrYmEbgEckPaKlaPCamYyRkúmh‘un Edlkarbg;buBVlaPFanar:ab;rgeTAtamkalkMNt;énbNÑsnüar:ab;rg.",
                                          style: TextStyle(
                                              fontSize: 13, font: khmerF)),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                            "¬x¦ GtßRbeyaCn_BiessRtÚv)anFana RtÚv)anKNnaedayykGRtakarR)ak; 2°énTwkR)ak;Fanar:ab;rg KuNnwgcMnYnqñaMénkalkMNt;énbNÑsnüar:ab;rg sRmab;Gñkbg;buBVlaPFanar:ab;rgEdlmanGayuenAeBlcab;epþImFana",
                                            style: TextStyle(
                                                fontSize: 13, font: khmerF)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 20, left: 13.7),
                                        child: Text(
                                          "eRkam 50qñaMKitRtwméf¶xYbkMeNItcugeRkay edayELksRmab;Gñkbg;buBVlaPFanar:ab;rgEdlmanGayuenAeBlcab;epþImFanacab;BI 50qñaMeLIgeTAKitRtwméf¶xYbkMeNItcugeRkayGRtakarR)ak;1°énTwkR)ak;Fanar:ab;rg",
                                          style: TextStyle(
                                              fontSize: 13, font: khmerF),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 30, left: 13.7),
                                        child: Text(
                                            "KuNnwgcMnYnqñaMénkalkMNt;énbNÑsnüar:ab;rgnwgRtÚv)anykmkKNna. GtßRbeyaCn_BiessRtÚv)anFananwgRtÚvTUTat;EteBldl;kalkMNt;énbNÑsnüar:ab;rgb:ueNÑaH.",
                                            style: TextStyle(
                                                fontSize: 13, font: khmerF)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 40),
                                        child: Text(
                                            "¬K¦ bNÑsnüar:ab;rgenHnwgTTYl)annUvtémøsac;R)ak; bnÞab;BIbNÑsnüar:ab;rgenHRtÚv)ancUlCaFrmankñúgry³eBly:agtic 2qñaM.",
                                            style: TextStyle(
                                                fontSize: 13, font: khmerF)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 50),
                                        child: Row(children: [
                                          Text("¬X¦",
                                              style: TextStyle(
                                                  fontSize: 13, font: khmerF)),
                                          SizedBox(width: 2.5),
                                          Text(
                                              "xagelIenHCakarbgðajGMBIplitplFanar:ab;rgEtb:ueNÑaH. GtßRbeyaCn_Edl)anBiBN’naenATIenH KWRtÚvGnuelamtam x niglkçxNÐTaMgGs;EdlmanEcgenAkñúgkic©snüar:ab;rg.",
                                              style: TextStyle(
                                                  fontSize: 13, font: khmerF))
                                        ]),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 60),
                                        child: Text(
                                            "¬g¦ Rkúmh‘unGacTUTat;GtßRbeyaCn_mrNPaBb¤BikarPaBTaMgRsúgnigCaGciRnéþy_bNþalmkBIRKb;mUlehtub¤GtßRbeyaCn_mrNPaBb¤BikarPaBTaMgRsúgnigCaGciéRnþy_ bNþalmkBIeRKaHfñak;EtmYyb:ueNÑaH.",
                                            style: TextStyle(
                                                fontSize: 13, font: khmerF)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 80),
                                        child: Text(
                                            "sMKal;³ taragsmÁal;bgðajBIplitplenHnwgRtÚvGs;suBlPaBry³eBl30éf¶eRkaykalbriecäTe)aHBum<xageRkam.",
                                            style: TextStyle(
                                                fontSize: 13, font: khmerF)),
                                      ),
                                    ]),
                                  )
                                : SizedBox(height: 0)
                            : SizedBox(height: 0)
                  ]))
                ])))
              ]),
              getPdfStatusKh()
                  ? (int.parse(policyTerm) >= 30)
                      ? Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Stack(children: [
                            Text(
                                "¬k¦ enHKWCaKeRmagFanar:ab;rgTayC¢TanEdlminmankarcUlrYmEbgEckPaKlaPCamYyRkúmh‘un Edlkarbg;buBVlaPFanar:ab;rgeTAtamkalkMNt;énbNÑsnüar:ab;rg.",
                                style: TextStyle(fontSize: 13, font: khmerF)),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                  "¬x¦ GtßRbeyaCn_BiessRtÚv)anFana RtÚv)anKNnaedayykGRtakarR)ak; 2°énTwkR)ak;Fanar:ab;rg KuNnwgcMnYnqñaMénkalkMNt;énbNÑsnüar:ab;rg sRmab;Gñkbg;buBVlaPFanar:ab;rgEdlmanGayuenAeBlcab;epþImFana",
                                  style: TextStyle(fontSize: 13, font: khmerF)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20, left: 13.7),
                              child: Text(
                                "eRkam 50qñaMKitRtwméf¶xYbkMeNItcugeRkay edayELksRmab;Gñkbg;buBVlaPFanar:ab;rgEdlmanGayuenAeBlcab;epþImFanacab;BI 50qñaMeLIgeTAKitRtwméf¶xYbkMeNItcugeRkayGRtakarR)ak;1°énTwkR)ak;Fanar:ab;rg",
                                style: TextStyle(fontSize: 13, font: khmerF),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 30, left: 13.7),
                              child: Text(
                                  "KuNnwgcMnYnqñaMénkalkMNt;énbNÑsnüar:ab;rgnwgRtÚv)anykmkKNna. GtßRbeyaCn_BiessRtÚv)anFananwgRtÚvTUTat;EteBldl;kalkMNt;énbNÑsnüar:ab;rgb:ueNÑaH.",
                                  style: TextStyle(fontSize: 13, font: khmerF)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Text(
                                  "¬K¦ bNÑsnüar:ab;rgenHnwgTTYl)annUvtémøsac;R)ak; bnÞab;BIbNÑsnüar:ab;rgenHRtÚv)ancUlCaFrmankñúgry³eBly:agtic 2qñaM.",
                                  style: TextStyle(fontSize: 13, font: khmerF)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Row(children: [
                                Text("¬X¦",
                                    style:
                                        TextStyle(fontSize: 13, font: khmerF)),
                                SizedBox(width: 2.5),
                                Text(
                                    "xagelIenHCakarbgðajGMBIplitplFanar:ab;rgEtb:ueNÑaH. GtßRbeyaCn_Edl)anBiBN’naenATIenH KWRtÚvGnuelamtam x niglkçxNÐTaMgGs;EdlmanEcgenAkñúgkic©snüar:ab;rg.",
                                    style:
                                        TextStyle(fontSize: 13, font: khmerF))
                              ]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 60),
                              child: Text(
                                  "¬g¦ Rkúmh‘unGacTUTat;GtßRbeyaCn_mrNPaBb¤BikarPaBTaMgRsúgnigCaGciRnéþy_bNþalmkBIRKb;mUlehtub¤GtßRbeyaCn_mrNPaBb¤BikarPaBTaMgRsúgnigCaGciéRnþy_ bNþalmkBIeRKaHfñak;EtmYyb:ueNÑaH.",
                                  style: TextStyle(fontSize: 13, font: khmerF)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 80),
                              child: Text(
                                  "sMKal;³ taragsmÁal;bgðajBIplitplenHnwgRtÚvGs;suBlPaBry³eBl30éf¶eRkaykalbriecäTe)aHBum<xageRkam.",
                                  style: TextStyle(fontSize: 13, font: khmerF)),
                            ),
                          ]),
                        )
                      : SizedBox(height: 0)
                  : SizedBox(height: 0),
            ]));
    return pdf;
  }
}
