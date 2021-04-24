import 'dart:io';

import 'package:align_positioned/align_positioned.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:forte_life/notification_plugin.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';
import 'package:forte_life/widgets/custom_alert_dialog.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;

class PDFScreenProtectUI extends StatefulWidget {
  PDFScreenProtectUI({this.pdf, this.scaffoldKey});

  final pw.Document pdf;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _PDFScreenProtectUIState createState() => _PDFScreenProtectUIState();
}

class _PDFScreenProtectUIState extends State<PDFScreenProtectUI> {
  File file;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    notificationPlugin.setListenerForLowerVersion(onNotificationLowerVersion);
    showPDF();
  }

  onNotificationLowerVersion(ReceivedNotification receivedNotification) {}
  onNotificationClicked(String payload) {}

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }
    return await getApplicationDocumentsDirectory();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController fileName = new TextEditingController();
    AppProvider appProvider = Provider.of<AppProvider>(context);
    final mq = MediaQuery.of(context);
    Map<String, dynamic> lang = appProvider.lang;
    file = File("${appProvider.rootPath}/fortelife.pdf");
    showAlertDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
        contentPadding: EdgeInsets.symmetric(
            horizontal: DeviceUtils.getResponsive(
                mq: mq,
                appProvider: appProvider,
                onPhone: 15.0,
                onTablet: 100.0),
            vertical: DeviceUtils.getResponsive(
                mq: mq,
                appProvider: appProvider,
                onPhone: 30.0,
                onTablet: 100.0)),
        title: Center(
            child: Container(
                child: Text(
          lang['save_pdf'],
          style: TextStyle(
              color: Color(0xFF8AB84B),
              fontFamily: "Kano",
              fontSize: DeviceUtils.getResponsive(
                  mq: mq,
                  appProvider: appProvider,
                  onPhone: 18.0,
                  onTablet: 36.0),
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
                      color: Colors.black,
                      fontSize: DeviceUtils.getResponsive(
                          mq: mq,
                          appProvider: appProvider,
                          onPhone: 15.0,
                          onTablet: 30.0),
                      fontFamily: "Kano"),
                ),
                SizedBox(
                    width: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 5.0,
                        onTablet: 10.0)),
                Expanded(
                  child: Container(
                    width: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: double.infinity,
                        onTablet: 240.0),
                    height: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 50.0,
                        onTablet: 100.0),
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
                          contentPadding: EdgeInsets.only(
                              left: DeviceUtils.getResponsive(
                                  mq: mq,
                                  appProvider: appProvider,
                                  onPhone: 5.0,
                                  onTablet: 10.0),
                              top: DeviceUtils.getResponsive(
                                  mq: mq,
                                  appProvider: appProvider,
                                  onPhone: 15.0,
                                  onTablet: 30.0)),
                          isDense: true,
                          hintText: "ForteLife's PDF",
                          hintStyle: TextStyle(
                              fontFamily: "Kano",
                              fontSize: DeviceUtils.getResponsive(
                                  mq: mq,
                                  appProvider: appProvider,
                                  onPhone: 15.0,
                                  onTablet: 30.0),
                              color: Colors.black.withOpacity(0.5))),
                      style: TextStyle(
                          fontFamily: "Kano",
                          fontSize: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 15.0,
                              onTablet: 30.0),
                          color: Colors.black),
                    ),
                  ),
                ),
              ]),
            ]),
        actions: [
          FlatButton(
            child: Text(
              lang['save'],
              style: TextStyle(
                  fontSize: DeviceUtils.getResponsive(
                      mq: mq,
                      appProvider: appProvider,
                      onPhone: 15.0,
                      onTablet: 30.0)),
            ),
            onPressed: () async {
              if (fileName.text.isNotEmpty) {
                final saveDir = await _getDownloadDirectory();
                final newFileName = "Protect- " + fileName.text + ".pdf";
                final newFilePath = path.join(saveDir.path, newFileName);
                File newFile = new File(newFilePath);
                if (await newFile.exists()) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Image.asset("assets/icons/attention.png",
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
                          content: Text(
                            lang['file_named'] +
                                newFileName.toString() +
                                lang['exist'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: DeviceUtils.getResponsive(
                                  mq: mq,
                                  appProvider: appProvider,
                                  onPhone: 22.0,
                                  onTablet: 44.0),
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
                        title: lang['saved_1'],
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
                        details: lang['file_named'] +
                            newFileName.toString() +
                            lang['saved'],
                        actionButtonTitle: lang['open_file'],
                        actionButtonTitleTwo: lang['close'],
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
                        content: Text(
                          lang['file_empty'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: DeviceUtils.getResponsive(
                                mq: mq,
                                appProvider: appProvider,
                                onPhone: 22.0,
                                onTablet: 44.0),
                            fontFamily: "Kano",
                          ),
                        ));
                  },
                );
            },
          ),
          FlatButton(
            child: Text(lang['cancel'],
                style: TextStyle(
                    fontSize: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 15.0,
                        onTablet: 30.0))),
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
        moveVerticallyByContainerWidth: DeviceUtils.getResponsive(
            mq: mq, appProvider: appProvider, onPhone: -0.1, onTablet: -0.025),
        moveHorizontallyByChildHeight: -0.25,
        child: SizedBox(
          height: DeviceUtils.getResponsive(
              mq: mq, appProvider: appProvider, onPhone: 50.0, onTablet: 100.0),
          width: DeviceUtils.getResponsive(
              mq: mq, appProvider: appProvider, onPhone: 50.0, onTablet: 100.0),
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
    file = File("$rootPath/fortelife.pdf");
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
