import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forte_life/constants/constants.dart';
import 'package:forte_life/notification_plugin.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  CurvedAnimation curveAnimation;
  SharedPreferences prefs;
  AppProvider appProvider;
  final splashDelay = 8;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1600),
    );

    curveAnimation = CurvedAnimation(
      parent: animationController,
      curve: Interval(0.1, 0.5, curve: Curves.linear),
    );

    animation = Tween(
      begin: 0.0001,
      end: 1.0,
    ).animate(curveAnimation);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.stop();
        animationController.reverse();
      }
    });

    animationController.forward();
    runAppInitialization();
    super.initState();
  }

  Future<void> determineInitialRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //TODO if the user is offline for 1 full day: remove token
    // prefs.remove(APP_ACCESS_TOKEN);
    //
    String accessToken = prefs.getString(APP_ACCESS_TOKEN) ?? '';

    if (accessToken.isEmpty) {
      Future.delayed(Duration(milliseconds: 500));
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      try {
        await authProvider.getCurrentUser(token: accessToken);
        Navigator.pushNamedAndRemoveUntil(context, '/main_flow', (_) => false);
      } on DioError catch (error) {
        print('error $error');
      }
    }
  }

  //TODO check if the user is offline for 1 full day
  Future<DateTime> getOfflineDateTime() async {}

  Future<void> setExternalDirectory() async {
    Directory platformDirectory;
    final prefs = await SharedPreferences.getInstance();
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    if (Platform.isAndroid) {
      platformDirectory = await getExternalStorageDirectory();
    } else {
      platformDirectory = await getApplicationDocumentsDirectory();
      print(Platform.operatingSystem + "&" + platformDirectory.path);
    }
    await prefs.setString("ROOT_PATH", platformDirectory.path);
    await Future.delayed(const Duration(milliseconds: 1000));
    appProvider.rootPath = prefs.getString("ROOT_PATH");
  }

  Future<void> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);
    final prefs = await SharedPreferences.getInstance();
    final rootPath = prefs.getString("ROOT_PATH");
    final file = new File("$rootPath/logo.png");
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }

  Future<void> getFontFileFromAssets() async {
    final prefs = await SharedPreferences.getInstance();
    final rootPath = prefs.getString("ROOT_PATH");
    final data =
        await rootBundle.load("assets/fonts/LiberationSans-Regular.ttf");
    final dataBold =
        await rootBundle.load("assets/fonts/LiberationSans-Bold.ttf");
    final khmerData3 =
        await rootBundle.load("assets/fonts/Kantumruy-Regular.ttf");
    final font = new File("$rootPath/LiberationSans-Regular.ttf");
    final fontBold = new File("$rootPath/LiberationSans-Bold.ttf");
    final khmerFont3 = new File("$rootPath/Kantumruy-Regular.ttf");
    await font.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    await fontBold.writeAsBytes(dataBold.buffer
        .asUint8List(dataBold.offsetInBytes, dataBold.lengthInBytes));
    await khmerFont3.writeAsBytes(khmerData3.buffer
        .asUint8List(khmerData3.offsetInBytes, khmerData3.lengthInBytes));
  }

  void runAppInitialization() async {
    AppProvider appProvider = Provider.of(context, listen: false);
    appProvider.setAppOrientation();
    await Future.delayed(const Duration(milliseconds: 4600));
    await appProvider.requestPermissions();
    // await isFirstTime();
    await appProvider.getDeviceType(MediaQuery.of(context).size.shortestSide);
    await setExternalDirectory();
    await getImageFileFromAssets("assets/pictures/android/logo/logo.png");
    await getFontFileFromAssets();
    await appProvider.getLanguage();
    await notificationPlugin.init();
    await determineInitialRoute();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: animation,
          child: Image.asset(
            "assets/pictures/android/logo/logo.png",
            width: 400,
            height: 400,
          ),
        ),
      ),
    );
  }
}
