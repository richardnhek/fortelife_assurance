import 'package:flutter/material.dart';
import 'package:forte_life/constants/constants.dart';
import 'package:forte_life/providers/auth_provider.dart';
import 'package:forte_life/widgets/loading_modal.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _newPasswordController = new TextEditingController(text: '');
  final _confirmController = new TextEditingController(text: '');

  void _onChangePassword(scaffoldContext) async {
    BuildContext loadingModalContext;
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
        }
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            loadingModalContext = context;
            return LoadingModal();
          },
        );
        try {
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          final prefs = await SharedPreferences.getInstance();
          final agentID = prefs.getString(AGENT_ID);
          await authProvider.changePassword(_newPasswordController.text);
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
                    "Password Changed Successfully, Please Log In Again",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "Kano",
                    ),
                  ));
            },
          );
          // Navigator.of(loadingModalContext).pop();
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacementNamed('/login');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: 400, minHeight: 300, minWidth: 250, maxWidth: 300),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.lock_outline_rounded,
                        size: 60,
                        color: Color(0xFFD31145),
                      )),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 180,
                      child: Text(
                        "Change Password",
                        style: TextStyle(
                            color: Color(0xFFD31145),
                            fontSize: 22,
                            fontFamily: "Kano",
                            fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Text(
                      "New Password: ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: "Kano"),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 21),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFB8B8B8))),
                        child: TextFormField(
                          controller: _newPasswordController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              disabledBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5, top: 15),
                              isDense: true,
                              hintText: "New Password",
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
                  SizedBox(height: 10),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Text(
                      "Confirm Password: ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: "Kano"),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFB8B8B8))),
                        child: TextFormField(
                          controller: _confirmController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              disabledBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 5, top: 15),
                              isDense: true,
                              hintText: "Confirm Password",
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
                  SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: FlatButton(
                      color: Color(0xFF8AB84B),
                      onPressed: () => _onChangePassword(context),
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Kano",
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
