import 'dart:io';

import 'package:align_positioned/align_positioned.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';
import 'package:forte_life/widgets/custom_alert_dialog.dart';
import 'package:open_file/open_file.dart';
import '../../notification_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;

class PDFScreenEducationUI extends StatefulWidget {
  PDFScreenEducationUI({this.pdf});

  final pw.Document pdf;
  @override
  _PDFScreenEducationUIState createState() => _PDFScreenEducationUIState();
}

class _PDFScreenEducationUIState extends State<PDFScreenEducationUI> {
  File file;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    notificationPlugin.setListenerForLowerVersion(onNotificationLowerVersion);
    showPDF();
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }
    return await getApplicationDocumentsDirectory();
  }

  onNotificationLowerVersion(ReceivedNotification receivedNotification) {}
  onNotificationClicked(String payload) {
    OpenFile.open(payload);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController fileName = new TextEditingController();
    AppProvider appProvider = Provider.of<AppProvider>(context);
    final mq = MediaQuery.of(context);
    Map<String, dynamic> lang = appProvider.lang;
    file = File("${appProvider.rootPath}/fortelife-education.pdf");
    showAlertDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        title: Center(
            child: Container(
                child: Text(
          lang['save_pdf'],
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
                  lang['file_name'] + ": ",
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
            child: Text(lang['save']),
            onPressed: () async {
              if (fileName.text.isNotEmpty) {
                final saveDir = await _getDownloadDirectory();
                final newFileName = "Education- " + fileName.text + ".pdf";
                final newFilePath = path.join(saveDir.path, newFileName);
                File newFile = new File(newFilePath);
                if (await newFile.exists()) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Image.asset("assets/icons/attention.png",
                              width: 60, height: 60),
                          content: Text(
                            "File Named $newFileName Already Exists",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: "Kano",
                            ),
                          ));
                    },
                  );
                } else {
                  savePDF(newFile, widget.pdf);
                  await notificationPlugin.setOnSelectNotification(
                      onNotificationClicked(newFilePath));
                  await notificationPlugin.showNotification();
                  Navigator.of(context).pop();
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return CustomAlertDialog(
                        appProvider: appProvider,
                        mq: mq,
                        title: "Saved",
                        isPrompt: true,
                        icon: Image.asset("assets/icons/check.png",
                            width: DeviceUtils.getResponsive(
                                mq: mq,
                                appProvider: appProvider,
                                onPhone: 60.0,
                                onTablet: 120.0),
                            height: DeviceUtils.getResponsive(
                                mq: mq,
                                appProvider: appProvider,
                                onPhone: 60.0,
                                onTablet: 120.0)),
                        details: "File Named $newFileName Saved Successfully",
                        actionButtonTitle: "Open File",
                        actionButtonTitleTwo: "Close",
                        onActionButtonPressed: () {
                          OpenFile.open(newFilePath);
                        },
                        onActionButtonPressedTwo: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                }
              } else
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Image.asset("assets/icons/attention.png",
                            width: 60, height: 60),
                        content: Text(
                          "File Name Can't Be Empty",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: "Kano",
                          ),
                        ));
                  },
                );
            },
          ),
          FlatButton(
            child: Text(lang['cancel']),
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
        child: SizedBox(
          height: DeviceUtils.getResponsive(
              mq: mq, appProvider: appProvider, onPhone: 40.0, onTablet: 80.0),
          width: DeviceUtils.getResponsive(
              mq: mq, appProvider: appProvider, onPhone: 40.0, onTablet: 80.0),
          child: FloatingActionButton(
            child: Icon(
              Icons.save_alt_outlined,
              size: DeviceUtils.getResponsive(
                  mq: mq,
                  appProvider: appProvider,
                  onPhone: 24.0,
                  onTablet: 48.0),
              color: Colors.white,
            ),
            backgroundColor: Color(0xFF8AB84B),
            onPressed: () {
              showAlertDialog(context);
            },
          ),
        ),
      ),
    ]);
  }

  Future showPDF() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    getPDF();
  }

  Future getPDF() async {
    final prefs = await SharedPreferences.getInstance();
    final rootPath = prefs.getString("ROOT_PATH");
    file = File("$rootPath/fortelife-education.pdf");
    if (this.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void dispose() {
    super.dispose();
  }

  //Save PDF in local storage
  Future savePDF(File file, pw.Document pdf) async {
    await file.writeAsBytes(await pdf.save());
  }
  //
}
