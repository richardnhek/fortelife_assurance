import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forte_life/providers/parameters_provider.dart';
import 'package:forte_life/screens/pdf/pdf_screen_education_ui.dart';
import 'package:forte_life/widgets/pdf/pdf_education_widget.dart';
import 'package:flutter/widgets.dart' as w;
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

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
    savePDF(file, pdf);
  }
  //

  //Save PDF in local storage
  Future savePDF(File file, pw.Document pdf) async {
    await file.writeAsBytes(pdf.save());
  }
  //

  pw.Document pdf = pw.Document();
  final file = File(
      "/storage/emulated/0/Android/data/com.reahu.forte_life/files/fortelife-education.pdf");
  @override
  w.Widget build(BuildContext context) {
    ParametersProvider parametersProvider =
        Provider.of<ParametersProvider>(context);
    pdf = PDFWidgetEdu().createPDF(
      "Forte Education-18",
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
    );
    return PDFScreenEducationUI(
      pdf: pdf,
    );
  }
}
