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
    // bool isFirstTime = prefs.getBool('first_time');

    if (accessToken.isEmpty) {
      Future.delayed(Duration(milliseconds: 500));
      // if(isFirstTime == true) {
      //   Navigator.of(context).pushReplacementNamed('/login');
      // }
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

  // Future<bool> isFirstTime() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   var isFirstTime = prefs.getBool('first_time');
  //   if (isFirstTime != null && !isFirstTime) {
  //     prefs.setBool('first_time', false);
  //     return false;
  //   } else {
  //     prefs.setBool('first_time', false);
  //     return true;
  //   }
  // }

  //TODO check if the user is offline for 1 full day
  // Future<DateTime> getOfflineDateTime() async {
  //
  // }
  //

  Future<void> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);

    final file = new File(
        "/storage/emulated/0/Android/data/com.reahu.forte_life/files/logo.png");
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }

  Future<void> getFontFileFromAssets() async {
    final data =
        await rootBundle.load("assets/fonts/LiberationSans-Regular.ttf");
    final dataBold =
        await rootBundle.load("assets/fonts/LiberationSans-Bold.ttf");
    final font = new File(
        "/storage/emulated/0/Android/data/com.reahu.forte_life/files/LiberationSans-Regular.ttf");
    final fontBold = new File(
        "/storage/emulated/0/Android/data/com.reahu.forte_life/files/LiberationSans-Bold.ttf");
    await font.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    await fontBold.writeAsBytes(dataBold.buffer
        .asUint8List(dataBold.offsetInBytes, dataBold.lengthInBytes));
  }

  void runAppInitialization() async {
    AppProvider appProvider = Provider.of(context, listen: false);
    appProvider.setAppOrientation();
    await Future.delayed(const Duration(milliseconds: 4600));
    // await isFirstTime();
    await appProvider.requestPermissions();
    await getExternalStorageDirectory();
    await getApplicationDocumentsDirectory();
    await getImageFileFromAssets("assets/pictures/android/logo/logo.png");
    await getFontFileFromAssets();
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
