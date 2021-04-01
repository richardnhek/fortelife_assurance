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
      this.isRequired});

  final dynamic value;
  final List<dynamic> items;
  final Function onChange;
  final String title;
  final bool errorVisible;
  final bool isRequired;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
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
                  itemHeight: appProvider.language == 'kh' ? 55 : 53,
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
      ]),
    );
  }
}
