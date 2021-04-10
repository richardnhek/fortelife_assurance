import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:provider/provider.dart';

class CustomDropDown extends StatelessWidget {
  CustomDropDown(
      {this.value,
      this.items,
      this.onChange,
      this.title,
      this.errorVisible,
      this.isRequired,
      this.appProvider});

  final dynamic value;
  final List<dynamic> items;
  final Function onChange;
  final String title;
  final bool errorVisible;
  final bool isRequired;
  final AppProvider appProvider;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5),
      child: Center(
        child: DropdownButtonHideUnderline(
          child: Center(
            child: DropdownButton(
                iconSize: 15,
                itemHeight: 50,
                value: value,
                isExpanded: true,
                hint: Text(
                  title,
                  style: TextStyle(
                      fontFamily: "Kano",
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.5)),
                ),
                items: items,
                onChanged: onChange),
          ),
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(
              color:
                  isRequired == false ? Color(0xFFB8B8B8) : Color(0xFFD31145))),
    );
  }
}
