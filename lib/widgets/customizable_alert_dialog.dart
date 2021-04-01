import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomizableAlertDialog extends StatelessWidget {
  const CustomizableAlertDialog(
      {this.icon,
      this.title,
      this.details,
      this.onActionButtonPressed,
      this.onActionButtonPressedTwo,
      this.firstWidget,
      this.firstHeight,
      this.secondWidget,
      this.secondHeight});

  final Widget icon;
  final String title;
  final String details;
  final Function onActionButtonPressed;
  final Function onActionButtonPressedTwo;
  final Widget firstWidget;
  final Widget secondWidget;
  final double firstHeight;
  final double secondHeight;

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
                        color: Color(0xFF8AB84B),
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
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  height: firstHeight,
                  child: GestureDetector(
                      onTap: onActionButtonPressed, child: firstWidget),
                ),
                SizedBox(width: 40),
                SizedBox(
                  height: secondHeight,
                  child: GestureDetector(
                      onTap: onActionButtonPressedTwo, child: secondWidget),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
