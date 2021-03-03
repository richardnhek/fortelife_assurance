import 'package:flutter/material.dart';

class DisabledField extends StatelessWidget {
  DisabledField({this.formController, this.title});

  final TextEditingController formController;
  final String title;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 60,
        minHeight: 40,
      ),
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.12),
              border: Border.all(color: Color(0xFFB8B8B8))),
          child: TextFormField(
            readOnly: true,
            textAlignVertical: TextAlignVertical.bottom,
            controller: formController,
            decoration: InputDecoration(
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 5, top: 10, bottom: 10),
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
              fontFamily: "Biko",
            ),
            autovalidateMode: AutovalidateMode.always,
          ),
        ),
      ]),
    );
  }
}
