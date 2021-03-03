import 'dart:io';

import 'package:align_positioned/align_positioned.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;

class PDFScreenProtectUI extends StatefulWidget {
  PDFScreenProtectUI({this.pdf});

  final pw.Document pdf;

  @override
  _PDFScreenProtectUIState createState() => _PDFScreenProtectUIState();
}

class _PDFScreenProtectUIState extends State<PDFScreenProtectUI> {
  File file = File(
      "/storage/emulated/0/Android/data/com.reahu.forte_life/files/fortelife.pdf");
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    showPDF();
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }
    return await getApplicationDocumentsDirectory();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController fileName = new TextEditingController();
    showAlertDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        title: Center(
            child: Container(
                child: Text(
          "Save PDF",
          style: TextStyle(
              color: Color(0xFF8AB84B),
              fontFamily: "Kano",
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ))),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Text(
                  "File Name: ",
                  style: TextStyle(
                      color: Colors.black, fontSize: 14, fontFamily: "Kano"),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFB8B8B8))),
                    child: TextFormField(
                      controller: fileName,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 5, top: 15),
                          isDense: true,
                          hintText: "ForteLife's PDF",
                          hintStyle: TextStyle(
                              fontFamily: "Kano",
                              fontSize: 15,
                              color: Colors.black.withOpacity(0.5))),
                      style: TextStyle(
                          fontFamily: "Kano",
                          fontSize: 14,
                          color: Colors.black),
                    ),
                  ),
                ),
              ]),
            ]),
        actions: [
          FlatButton(
            child: Text("Save"),
            onPressed: () async {
              if (fileName.text.isNotEmpty) {
                final saveDir = await _getDownloadDirectory();
                final newFileName = fileName.text + ".pdf";
                final newFilePath = path.join(saveDir.path, newFileName);
                File newFile = new File(newFilePath);
                if (await newFile.exists()) {
                  print("File Already Exists");
                } else {
                  savePDF(newFile, widget.pdf);
                  Navigator.of(context).pop();
                }
              } else
                print("Error No File Name");
            },
          ),
          FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return Stack(children: [
      Container(
        child: Center(
            child: _isLoading == true
                ? Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: SfPdfViewer.file(
                      file,
                      initialZoomLevel: 1,
                      pageSpacing: 0,
                    ),
                  )),
      ),
      AlignPositioned(
        alignment: Alignment.bottomRight,
        moveVerticallyByContainerWidth: -0.1,
        moveHorizontallyByChildHeight: -0.25,
        child: FloatingActionButton(
          child: Icon(
            Icons.save_alt_outlined,
            size: 24,
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF8AB84B),
          onPressed: () {
            showAlertDialog(context);
          },
        ),
      ),
    ]);
  }

  Future showPDF() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    getPDF();
  }

  Future getPDF() async {
    file = File(
        "/storage/emulated/0/Android/data/com.reahu.forte_life/files/fortelife.pdf");
    setState(() {
      _isLoading = false;
    });
  }

  //Save PDF in local storage
  Future savePDF(File file, pw.Document pdf) async {
    await file.writeAsBytes(pdf.save());
  }
  //
}
