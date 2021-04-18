import 'package:flutter/material.dart';
import 'package:forte_life/constants/constants.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/providers/auth_provider.dart';
import 'package:forte_life/screens/profile/profile_screen_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _newPasswordController = new TextEditingController(text: '');
  final _confirmController = new TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    initializeProfile();
  }

  Future<void> initializeProfile() async {
    await getUsername();
    await getLastLogin();
  }

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.userName = prefs.getString(AGENT_USERNAME);
  }

  Future<void> getLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.lastLogin = prefs.getString(LOGIN_DATE);
  }

  @override
  Widget build(BuildContext context) {
    void signOut() async {
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.logout(context);
        final appProvider = Provider.of<AppProvider>(context, listen: false);
        appProvider.activeTabIndex = 0;
        Navigator.of(context).pop();
        Navigator.pushNamedAndRemoveUntil(
            context, "/login", (Route<dynamic> route) => false);
        await Future.delayed(new Duration(milliseconds: 500));
      } catch (e) {
        await Future.delayed(new Duration(milliseconds: 500));
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(content: Text(e.toString()));
          },
        );
      }
    }

    void _onChangePassword(scaffoldContext) async {
      if (_newPasswordController.text.isNotEmpty) {
        if (_newPasswordController.text == "1234" ||
            _newPasswordController.text != _confirmController.text ||
            _newPasswordController.text.length < 4) {
          if (_newPasswordController.text == "1234") {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Image.asset("assets/icons/attention.png",
                        width: 60, height: 60),
                    content: Text(
                      "Password Can't Be Default",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Kano",
                        fontSize: 22,
                        color: Color(0xFFD31145),
                      ),
                    ));
              },
            );
          } else if (_confirmController.text != _newPasswordController.text) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Image.asset("assets/icons/attention.png",
                        width: 60, height: 60),
                    content: Text(
                      "Password Not\nMatched",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Kano",
                        fontSize: 22,
                        color: Color(0xFFD31145),
                      ),
                    ));
              },
            );
          } else if (_newPasswordController.text.length < 4) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Image.asset("assets/icons/attention.png",
                        width: 60, height: 60),
                    content: Text(
                      "Password Must Be At Least\n4 Characters",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Kano",
                        fontSize: 22,
                        color: Color(0xFFD31145),
                      ),
                    ));
              },
            );
          }
        } else
          try {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            final prefs = await SharedPreferences.getInstance();
            final agentID = prefs.getString(AGENT_ID);

            await authProvider.changePassword(_newPasswordController.text);
            Navigator.of(context).pop();
            await Future.delayed(new Duration(milliseconds: 500));
            showDialog(
              context: context,
              builder: (BuildContext context) {
                _newPasswordController.clear();
                _confirmController.clear();
                return AlertDialog(
                    title: Image.asset("assets/icons/check.png",
                        width: 60, height: 60),
                    content: Text(
                      "Password Changed Successfully",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Kano",
                      ),
                    ));
              },
            );
          } catch (e) {
            await Future.delayed(new Duration(milliseconds: 500));
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(content: Text(e.toString()));
              },
            );
          }
      } else
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Material(
              type: MaterialType.transparency,
              child: AlertDialog(
                  title: Image.asset("assets/icons/attention.png",
                      width: 60, height: 60),
                  content: Text(
                    "Password Can't Be Empty",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Kano",
                      fontSize: 22,
                      color: Color(0xFFD31145),
                    ),
                  )),
            );
          },
        );
    }

    return ProfileScreenUI(
      onLogOut: signOut,
      newPasswordController: _newPasswordController,
      confirmController: _confirmController,
      onChangePassword: _onChangePassword,
    );
  }
}
