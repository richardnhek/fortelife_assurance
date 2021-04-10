import 'package:flutter/material.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';

class DisabledField extends StatelessWidget {
  DisabledField({this.formController, this.title, this.mq, this.appProvider});

  final TextEditingController formController;
  final String title;
  final AppProvider appProvider;
  final MediaQueryData mq;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.12),
          border: Border.all(color: Color(0xFFB8B8B8))),
      child: Center(
        child: TextFormField(
          readOnly: true,
          textAlignVertical: TextAlignVertical.bottom,
          controller: formController,
          decoration: InputDecoration(
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 5, bottom: 5),
              isDense: true,
              hintText: title,
              labelText: title,
              labelStyle: TextStyle(
                  fontFamily: "Kano",
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.5)),
              hintStyle: TextStyle(
                  fontFamily: "Kano",
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.5))),
          keyboardType: TextInputType.number,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontFamily: "Kano",
          ),
          autovalidateMode: AutovalidateMode.always,
        ),
      ),
    );
  }
}
