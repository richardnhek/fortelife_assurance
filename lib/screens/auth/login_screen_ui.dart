import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:forte_life/widgets/username_field.dart';
import 'package:forte_life/widgets/password_field.dart';

class LoginScreenUI extends StatelessWidget {
  LoginScreenUI(
      {this.usernameController,
      this.passwordController,
      this.onSignInPress,
      this.scaffoldKey});

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final Function onSignInPress;
  final scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
                fit: BoxFit.fill,
                image: AssetImage("assets/pictures/android/gradient1.png"),
                gaplessPlayback: true),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.size.width / 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                "assets/pictures/android/logo/logo.png"),
                            fit: BoxFit.contain)),
                  ),
                  constraints: BoxConstraints(maxWidth: 300, maxHeight: 52),
                ),
                SizedBox(height: 50),
                UserNameField(
                  hintText: "Username",
                  tec: usernameController,
                ),
                SizedBox(
                  height: 15,
                ),
                PasswordField(
                  hintText: "Password",
                  tec: passwordController,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF6ABFBC), Color(0xFF8AB84B)])),
                  child: RaisedButton(
                    padding: EdgeInsets.all(10),
                    elevation: 2.5,
                    disabledElevation: 2.5,
                    disabledColor: Color(0xFF8AB84B),
                    color: Color(0xFF8AB84B),
                    onPressed: () => onSignInPress(context),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 17.5,
                          fontFamily: "Kano",
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Image(
                width: double.infinity,
                fit: BoxFit.fill,
                image: AssetImage("assets/pictures/android/gradient2.png"),
                gaplessPlayback: true),
          ),
        ],
      ),
    );
  }
}
