import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/screens/pdf/pdf_screen_education.dart';
import 'package:forte_life/screens/pdf/pdf_screen_protect.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PDFScreen extends StatefulWidget {
  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  final tabs = [BlankPDF(), PDFScreenProtect(), PDFScreenEdu()];

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          appProvider.activeTabIndex = 0;
        });
        Navigator.popAndPushNamed(context, "/main_flow");
        return true;
      },
      child: SafeArea(
        child: Container(
          child: Scaffold(
            body: tabs[appProvider.pdfScreenIndex],
          ),
        ),
      ),
    );
  }
}

class BlankPDF extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(child: Text("Blank")),
    );
  }
}
