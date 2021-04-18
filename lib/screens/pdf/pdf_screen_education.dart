import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/providers/parameters_provider.dart';
import 'package:forte_life/screens/pdf/pdf_screen_education_ui.dart';
import 'package:forte_life/widgets/pdf/pdf_education_widget.dart';
import 'package:flutter/widgets.dart' as w;
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PDFScreenEdu extends StatefulWidget {
  @override
  _PDFScreenEduState createState() => _PDFScreenEduState();
}

class _PDFScreenEduState extends State<PDFScreenEdu> {
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
    final file = File("$rootPath/fortelife-education.pdf");
    await file.writeAsBytes(await pdf.save());
  }
  //

  pw.Document pdf = pw.Document();

  @override
  w.Widget build(BuildContext context) {
    ParametersProvider parametersProvider =
        Provider.of<ParametersProvider>(context);
    AppProvider appProvider = Provider.of<AppProvider>(context);
    GlobalKey<ScaffoldState> scaffoldKey;
    pdf = PDFWidgetEdu().createPDF(
        "Forte Life Education-18",
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
        parametersProvider.isOnPolicy,
        appProvider.language,
        appProvider.rootPath);
    return Scaffold(
      key: scaffoldKey,
      body: PDFScreenEducationUI(
        pdf: pdf,
      ),
    );
  }
}
