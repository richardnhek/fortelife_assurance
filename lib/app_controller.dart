import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/screens/auth/change_password_screen.dart';
import 'package:forte_life/utils/app_utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'configs/theme.dart';
import 'screens/home/home_screen.dart';
import 'main_flow.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';

class AppController extends StatefulWidget {
  @override
  _AppControllerState createState() => _AppControllerState();
}

class _AppControllerState extends State<AppController> {
  final Map<String, Widget> routes = {
    "/": SplashScreen(),
    "/login": LoginScreen(),
    "/main_flow": MainFlow(),
    "/home": HomeScreen(),
    "/change_pass": ChangePasswordScreen()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('en'), const Locale('km')],
        initialRoute: "/",
        onGenerateRoute: (RouteSettings settings) {
          Route screen;
          switch (settings.name) {
            case '/login':
              return PageTransition(
                child: routes[settings.name],
                type: PageTransitionType.fade,
                settings: settings,
                duration: Duration(milliseconds: 1000),
                reverseDuration: Duration(milliseconds: 1200),
              );
              break;
            case '/main_flow':
              return PageTransition(
                child: routes[settings.name],
                type: PageTransitionType.fade,
                settings: settings,
                duration: Duration(milliseconds: 500),
                curve: Interval(0.1, 0.3, curve: Curves.linear),
                reverseDuration: Duration(milliseconds: 700),
              );
              break;
            default:
              {
                screen = MaterialPageRoute(
                  settings: settings,
                  builder: (BuildContext context) {
                    return routes[settings.name];
                  },
                );
                break;
              }
          }
          return screen;
        });
  }
}
