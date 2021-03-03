import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {this.icon,
      this.title,
      this.details,
      this.actionButtonTitle,
      this.actionButtonTitleTwo,
      this.onActionButtonPressed,
      this.onActionButtonPressedTwo,
      this.isPrompt});

  final Widget icon;
  final String title;
  final String details;
  final String actionButtonTitle;
  final String actionButtonTitleTwo;
  final Function onActionButtonPressed;
  final Function onActionButtonPressedTwo;
  final bool isPrompt;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              icon == null
                  ? Material()
                  : Align(
                      child: icon,
                      alignment: Alignment.center,
                    ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 150,
                  child: Text(
                    title,
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
              SizedBox(height: 10),
              Text(
                details,
                style: TextStyle(
                    color: Colors.black, fontFamily: "Kano", fontSize: 14),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 20),
              Visibility(
                visible: isPrompt,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    height: 50,
                    child: FlatButton(
                      color: Color(0xFF8AB84B),
                      onPressed: onActionButtonPressed,
                      child: Text(
                        actionButtonTitle,
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
                      color: Color(0xFFD31145),
                      onPressed: onActionButtonPressedTwo,
                      child: Text(
                        actionButtonTitleTwo,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Kano",
                            color: Colors.white),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
