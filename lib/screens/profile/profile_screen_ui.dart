import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/widgets/custom_alert_dialog.dart';
import 'package:provider/provider.dart';

class ProfileScreenUI extends StatelessWidget {
  ProfileScreenUI(
      {this.onLogOut,
      this.onChangePassword,
      this.newPasswordController,
      this.confirmController});
  final Function onLogOut;
  final Function onChangePassword;
  final TextEditingController newPasswordController;
  final TextEditingController confirmController;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final appProvider = Provider.of<AppProvider>(context);
    void _showExitDialog() {
      showDialog(
          context: context,
          builder: (ctx) => Center(
                child: CustomAlertDialog(
                  title: "Log Out",
                  icon: Icon(
                    Icons.logout,
                    size: 60,
                    color: Color(0xFFD31145),
                  ),
                  details: "Are you sure you want to log out?",
                  actionButtonTitle: "No",
                  actionButtonTitleTwo: "Yes",
                  isPrompt: true,
                  onActionButtonPressed: () {
                    Navigator.of(context).pop();
                  },
                  onActionButtonPressedTwo: () {
                    Navigator.of(context).pop();
                    onLogOut();
                  },
                ),
              ));
    }

    void _showChangePassword() {
      showDialog(
          context: context,
          builder: (ctx) => Material(
              type: MaterialType.transparency,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: 400,
                      minHeight: 300,
                      minWidth: 250,
                      maxWidth: 300),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white,
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
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
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
                                      border:
                                          Border.all(color: Color(0xFFB8B8B8))),
                                  child: TextFormField(
                                    controller: newPasswordController,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                        disabledBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(left: 5, top: 15),
                                        isDense: true,
                                        hintText: "New Password",
                                        hintStyle: TextStyle(
                                            fontFamily: "Kano",
                                            fontSize: 15,
                                            color:
                                                Colors.black.withOpacity(0.5))),
                                    style: TextStyle(
                                        fontFamily: "Kano",
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ]),
                        SizedBox(height: 10),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
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
                                      border:
                                          Border.all(color: Color(0xFFB8B8B8))),
                                  child: TextFormField(
                                    controller: confirmController,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                        disabledBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(left: 5, top: 15),
                                        isDense: true,
                                        hintText: "Confirm Password",
                                        hintStyle: TextStyle(
                                            fontFamily: "Kano",
                                            fontSize: 15,
                                            color:
                                                Colors.black.withOpacity(0.5))),
                                    style: TextStyle(
                                        fontFamily: "Kano",
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ]),
                        SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 50,
                                child: FlatButton(
                                  color: Color(0xFFD31145),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Kano",
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              SizedBox(
                                height: 50,
                                child: FlatButton(
                                  color: Color(0xFF8AB84B),
                                  onPressed: () => onChangePassword(context),
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Kano",
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                ),
              )));
    }

    void _showContactDialog() {
      print(appProvider.userName);
      showDialog(
          context: context,
          builder: (ctx) => Material(
                type: MaterialType.transparency,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: 270,
                        minHeight: 250,
                        minWidth: 250,
                        maxWidth: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                image: new AssetImage(
                                    "assets/pictures/android/logo/logo.png"),
                                fit: BoxFit.contain,
                              ),
                            ),
                            height: 40,
                            width: 125,
                          ),
                          Text(
                            "About Us",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                fontFamily: "Kano"),
                          ),
                          SizedBox(height: 25),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Phone No",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontFamily: "Kano"),
                                ),
                                Text(
                                  "(+855) 23 885 077 / 066",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.5,
                                      fontFamily: "Kano"),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Fax",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontFamily: "Kano"),
                                ),
                                Text(
                                  "(+855) 23 986 922",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.5,
                                      fontFamily: "Kano"),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontFamily: "Kano"),
                                ),
                                Text(
                                  "info@fortelifeassurance.com",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.5,
                                      fontFamily: "Kano"),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          FlatButton(
                            splashColor: Colors.blueAccent.withOpacity(0.16),
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.blueAccent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Stack(alignment: Alignment.topCenter, children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: new BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF92C04A), Color(0xFF6ABFBC)])),
                  height: mq.size.height / 3,
                  width: mq.size.width,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 600, minWidth: 500),
                child: Container(
                  margin: EdgeInsets.only(
                      top: mq.size.height / 4, left: 30, right: 30),
                  padding: EdgeInsets.only(top: 50),
                  width: double.infinity,
                  height: mq.size.height / 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5),
                      color: Color(0xFFFFFFFF),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.16),
                            blurRadius: 15,
                            spreadRadius: 1,
                            offset: Offset(3, 6)),
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Username: ${appProvider.userName}",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontFamily: "Kano"),
                      ),
                      Text(
                        "Last Active: 2 Hours Ago",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontFamily: "Kano"),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Language",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: "Kano"),
                            ),
                            Icon(Icons.language, color: Color(0xFF92C04A))
                          ],
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _showChangePassword,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Change Password",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: "Kano"),
                              ),
                              Icon(Icons.lock_outline, color: Color(0xFF92C04A))
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: _showContactDialog,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "Contact Us",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: "Kano"),
                              ),
                              Icon(Icons.contact_page_outlined,
                                  color: Color(0xFF92C04A))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      RaisedButton(
                          onPressed: _showExitDialog,
                          padding: EdgeInsets.all(10),
                          disabledColor: Color(0xFFD31145),
                          color: Color(0xFFD31145),
                          disabledElevation: 2.5,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Log Out",
                                style: TextStyle(
                                    fontSize: 17.5,
                                    color: Colors.white,
                                    fontFamily: "Kano",
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.logout,
                                size: 21,
                                color: Colors.white,
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: mq.size.height / 5.5),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.16),
                          blurRadius: 10,
                          offset: Offset(3, 6),
                          spreadRadius: 1.5)
                    ]),
                child: CircleAvatar(
                  maxRadius: 40,
                  minRadius: 35,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.white,
                  child: Image(
                    alignment: Alignment.bottomCenter,
                    image: AssetImage("assets/icons/agent.png"),
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
