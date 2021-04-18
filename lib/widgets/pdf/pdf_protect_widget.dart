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
      String rootPath) {
    //Final variables
    final file = File("$rootPath/logo.png").readAsBytesSync();
    final image = MemoryImage(file);
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
      0: FlexColumnWidth(0.45),
      1: FlexColumnWidth(1.85),
      2: FlexColumnWidth(1.85),
      3: FlexColumnWidth(0.7),
      4: FlexColumnWidth(2.65)
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

    List<double> getPremiumPayment(String paymentMode) {
      double premiumPayment = 0;
      double truePremium = 0;
      double premiumWithR = 0;
      double premiumRiderPM = 0;
      switch (paymentMode) {
        case "Yearly":
          {
            truePremium = yearlyNum;
            premiumPayment = yearlyNum;
            premiumWithR = totalPremium;
            premiumRiderPM = premiumRiderNum;
            break;
          }
        case "Half-yearly":
          {
            truePremium = halfPNum;
            premiumPayment = halfPNum * 2;
            premiumWithR = halfPNumR;
            premiumRiderPM = premiumRiderNum * 0.5178;
            break;
          }
        case "Quarterly":
          {
            truePremium = quarterlyPNum;
            premiumPayment = quarterlyPNum * 4;
            premiumWithR = quarterlyPNumR;
            premiumRiderPM = premiumRiderNum * 0.2635;
            break;
          }
        case "Monthly":
          {
            truePremium = monthlyPNum;
            premiumPayment = monthlyPNum * 12;
            premiumWithR = monthlyPNumR;
            premiumRiderPM = premiumRiderNum * 0.0888;
            break;
          }
      }
      double totalPremiumDisplay = truePremium + premiumRiderNum;
      List<double> premiumAndSale = [
        premiumPayment,
        totalPremiumDisplay,
        truePremium,
        premiumWithR,
        premiumRiderPM
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
                "${totalPremiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${allAccidents.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "-",
                "          -                              -                             -         "
              ],
            ];
            i++;
            allCauses = (basicSANum * 0.6) + riderSANum;
            allAccidents = (basicSANum * 1.2) + riderSANum;
            accumulatedPremiumNoRider += yearlyNum;
            accumulatedPremium += totalPremiumNum;
            dynamicRow.add([
              "$i",
              "${totalPremiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${allAccidents.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "-",
              "          -                              -                             -         "
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
                "${totalPremiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${allAccidents.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "-",
                "          -                              -                             -         "
              ],
            ];
            i++;
            allCauses = (basicSANum * 0.8) + riderSANum;
            allAccidents = (basicSANum * 1.6) + riderSANum;
            accumulatedPremiumNoRider += yearlyNum;
            accumulatedPremium += totalPremiumNum;
            dynamicRow.add([
              "$i",
              "${totalPremiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${allAccidents.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
              "-",
              "          -                              -                             -         "
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
                "${totalPremiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${allAccidents.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "-",
                "          -                              -                             -         "
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
                "${totalPremiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${allAccidents.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
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
            "${totalPremiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${allAccidents.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            cashValueStr,
            "          -                              -                             -         "
          ]);
          i++;
        } else {
          dynamicRow.add([
            "$i",
            "${totalPremiumNum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${accumulatedPremium.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            "${allCauses.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}            ${allAccidents.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
            cashValue
                .round()
                .toStringAsFixed(2)
                .replaceAllMapped(regExpNum, (Match m) => '${m[1]},'),
            "${basicSANum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}               ${getGSB().toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}               ${(basicSANum + getGSB()).toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}"
          ]);
          i++;
        }
      }

      return dynamicRow;
    }

    List<String> getDynamicHeaders() {
      List<String> dynamicHeader = [
        " End of \n Policy \n  Year",
        "                 Premium (USD)\n\n       Annualized     Accumulated",
        "               Death/TPD (USD)\n\n       All Causes        Accidents",
        "      Cash\n      Value",
        "   Guaranteed         Guaranteed     Total Maturity" +
            "\n" +
            " Maturity Benefit   Special Benefit     Benefit"
      ];
      return dynamicHeader;
    }

    Document pdf = Document();
    pdf.addPage(Page(
        margin: EdgeInsets.symmetric(horizontal: 20),
        pageFormat: PdfPageFormat.a4,
        build: (Context context) {
          return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              child: Expanded(
                  child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Image(image, width: 150, height: 80, fit: BoxFit.contain),
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
                SizedBox(height: 12.5),
                Text("SALES ILLUSTRATION",
                    style: TextStyle(
                        fontSize: 11.5,
                        font: boldF,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
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
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.5),
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
                        ]),
                        TableRow(children: [
                          Column(children: [
                            Padding(
                              padding: EdgeInsets.only(top: 2.5, bottom: 2.5),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Container(
                                            width: 100,
                                            child: Text("Life Proposed",
                                                style: TextStyle(
                                                    font: regularF,
                                                    fontSize: 8.25)))),
                                    SizedBox(width: 23.5),
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
                            ),
                            Padding(
                                padding: EdgeInsets.only(bottom: 2.5),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Container(
                                              width: 100,
                                              child: Text("Proposer",
                                                  style: TextStyle(
                                                      font: regularF,
                                                      fontSize: 8.25)))),
                                      SizedBox(width: 23.5),
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
                                    ]))
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
                                        left: 40, bottom: 2.5, top: 2.5),
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
                        ]),
                        TableRow(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                    width: 140,
                                                    child: Text(
                                                        "Basic Plan  : $title",
                                                        style: TextStyle(
                                                            font: regularF,
                                                            fontSize: 8.25)))),
                                            SizedBox(
                                                width: 105,
                                                child: PDFSubtitle(
                                                    isKhmer: false,
                                                    title:
                                                        "USD ${basicSANum.toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
                                                    font: regularF)),
                                            Padding(
                                              padding: EdgeInsets.only(left: 6),
                                              child: PDFSubtitle(
                                                  isKhmer: false,
                                                  title: policyTerm,
                                                  font: regularF),
                                            ),
                                            SizedBox(width: 12.5),
                                            PDFSubtitle(
                                                isKhmer: false,
                                                title: policyTerm,
                                                font: regularF)
                                          ]),
                                      addRider == true
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 2.5),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        width: 140,
                                                        child: Text(
                                                            "Rider          : $title" +
                                                                " Plus",
                                                            style: TextStyle(
                                                                font: regularF,
                                                                fontSize:
                                                                    8.25))),
                                                    SizedBox(width: 12.5),
                                                    PDFSubtitle(
                                                        isKhmer: false,
                                                        title:
                                                            "USD $riderSAStr",
                                                        font: regularF),
                                                    SizedBox(width: 14),
                                                    PDFSubtitle(
                                                        isKhmer: false,
                                                        title: policyTerm,
                                                        font: regularF),
                                                    SizedBox(width: 12),
                                                    PDFSubtitle(
                                                        isKhmer: false,
                                                        title: policyTerm,
                                                        font: regularF)
                                                  ]))
                                          : SizedBox(height: 0),
                                    ]),
                                Padding(
                                    padding: EdgeInsets.only(right: 3.5),
                                    child: PDFSubtitle(
                                        isKhmer: false,
                                        title: paymentMode,
                                        font: regularF))
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
                                EdgeInsets.only(left: 5, bottom: 2.5, top: 2.5),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: 140,
                                            child: Text("Basic Plan  : $title",
                                                style: TextStyle(
                                                    font: regularF,
                                                    fontSize: 8.25))),
                                        addRider == true
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(top: 2.5),
                                                width: 140,
                                                child: Text(
                                                    "Rider          : $title" +
                                                        " Plus",
                                                    style: TextStyle(
                                                        font: regularF,
                                                        fontSize: 8.25)))
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
                                            padding: EdgeInsets.only(top: 2.5),
                                            child: PDFSubtitle(
                                                isKhmer: false,
                                                title: addRider == true
                                                    ? "USD ${getPremiumPayment(paymentMode)[4].toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}"
                                                    : "",
                                                font: regularF)),
                                      ])
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
                                      isKhmer: false,
                                      title:
                                          "USD ${getPremiumPayment(paymentMode)[3].toStringAsFixed(2).replaceAllMapped(regExpNum, (Match m) => '${m[1]},')}",
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
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.5),
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
                                          isKhmer: false, title: "USD $halfP")
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
                        ])
                      ]),
                  SizedBox(height: 12.5),
                  Table.fromTextArray(
                      headers: getDynamicHeaders(),
                      columnWidths: columnWidthVal,
                      headerAlignment: Alignment.center,
                      cellPadding: EdgeInsets.only(
                          top: 2, right: 2.5, left: 2.5, bottom: 1.5),
                      headerHeight: 20,
                      cellHeight: 0.1,
                      headerPadding: const EdgeInsets.only(
                          right: 1.5, bottom: 1.5, left: 1.5, top: 1.5),
                      headerDecoration:
                          BoxDecoration(border: Border(bottom: BorderSide())),
                      headerStyle: TextStyle(font: boldF, fontSize: 8.25),
                      cellStyle: TextStyle(font: regularF, fontSize: 7.6),
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
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Flexible(
                        child: Text(
                            "1.	This is a Non-participating Endowment plan with premium payables throughout the term of the Policy." +
                                "\n" +
                                "2.	The Guaranteed Special Benefit shall be equal to 2% of Basic Sum Assured multiplied by the Policy term with entry age below 50 years last birthday and 1% of Basic Sum Assured multiplied by the policy term with age 50 years last birthday and above. The Guaranteed Special Benefit shall only be available upon maturity of the policy" +
                                "\n" +
                                "3.	This Policy will acquire a Cash Value after it has been in-force for a minimum of two years." +
                                "\n" +
                                "4. 	The above is for illustration purposes only. The benefits described herein are subject to all terms and conditions contained in the Policy contract."
                                    "\n" +
                                "5.	Pays the earlier of either Death due to All Causes, TPD due to All Causes, Death due to Accident or TPD due to Accident." +
                                "\n\n" +
                                "Note: This Sales Illustration shall be expired 30 days after print date below." +
                                "\n\n\n" +
                                "Print Date               : $currentDate",
                            style: TextStyle(fontSize: 8.25, font: regularF))),
                  ),
                ]))
              ])));
        }));
    return pdf;
  }
}
