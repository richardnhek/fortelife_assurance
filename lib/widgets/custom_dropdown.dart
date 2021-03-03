import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  CustomDropDown(
      {this.value,
      this.items,
      this.onChange,
      this.title,
      this.errorVisible,
      this.isRequired});

  final dynamic value;
  final List<dynamic> items;
  final Function onChange;
  final String title;
  final bool errorVisible;
  final bool isRequired;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 60, minHeight: 40),
      child: Stack(children: [
        Container(
          child: Padding(
            padding: EdgeInsets.only(left: 5),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  iconSize: 17.5,
                  value: value,
                  isExpanded: true,
                  itemHeight: 53,
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
          decoration: BoxDecoration(
              border: Border.all(
                  color: isRequired == false
                      ? Color(0xFFB8B8B8)
                      : Color(0xFFD31145))),
        ),
        AlignPositioned(
          alignment: Alignment.bottomLeft,
          maxChildHeight: 15,
          minChildHeightRatio: 0.4,
          minChildWidth: 15,
          maxChildWidthRatio: 0.9,
          dx: 5,
          dy: 2,
          child: Visibility(
            visible: errorVisible,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Color(0xFFD31145)),
                  color: Color(0xFFFEEBE9)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    "Error : $title can't be empty",
                    style: TextStyle(fontFamily: "Kano", fontSize: 10.5),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
