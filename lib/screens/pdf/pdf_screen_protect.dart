import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/providers/parameters_provider.dart';
import 'package:forte_life/screens/pdf/pdf_screen_protect_ui.dart';
import 'package:forte_life/widgets/pdf/pdf_protect_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PDFScreenProtect extends StatefulWidget {
  @override
  _PDFScreenProtectState createState() => _PDFScreenProtectState();
}

class _PDFScreenProtectState extends State<PDFScreenProtect> {
  @override
  void initState() {
    super.initState();

    getPDF();
  }

  //Get old PDF and throw it to savePDF
  Future getPDF() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    savePDF(pdf);
  }
  //

  //Save PDF in local storage
  Future savePDF(pw.Document pdf) async {
    final prefs = await SharedPreferences.getInstance();
    final rootPath = prefs.getString("ROOT_PATH");
    final file = File("$rootPath/fortelife.pdf");
    await file.writeAsBytes(await pdf.save());
  }
  //

  pw.Document pdf = pw.Document();

  @override
  Widget build(BuildContext context) {
    ParametersProvider parametersProvider =
        Provider.of<ParametersProvider>(context);
    AppProvider appProvider = Provider.of<AppProvider>(context);
    GlobalKey<ScaffoldState> scaffoldKey;
    pdf = PDFWidget().createPDF(
        "Forte Life Protect",
        appProvider.addRider,
        appProvider.differentPerson,
        parametersProvider.lpName,
        parametersProvider.lpAge,
        parametersProvider.lpGender,
        parametersProvider.lpOccupation,
        parametersProvider.pName,
        parametersProvider.pAge,
        parametersProvider.pGender,
        parametersProvider.pOccupation,
        parametersProvider.basicSA,
        parametersProvider.policyTerm,
        parametersProvider.paymentMode,
        parametersProvider.annualP,
        parametersProvider.premiumRider,
        parametersProvider.riderSA,
        parametersProvider.isOnPolicy,
        appProvider.rootPath);
    return Scaffold(
      key: scaffoldKey,
      body: PDFScreenProtectUI(
        scaffoldKey: scaffoldKey,
        pdf: pdf,
      ),
    );
  }
}
