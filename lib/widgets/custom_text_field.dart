import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.formLabel,
      this.formInputType,
      this.formController,
      this.onChange,
      this.onSaved,
      this.validateFunc,
      this.errorVisible,
      this.isRequired,
      this.onSubmitted,
      this.maxLength});

  final String formLabel;
  final TextInputType formInputType;
  final TextEditingController formController;
  final Function onChange;
  final Function onSaved;
  final Function onSubmitted;
  final Function validateFunc;
  final bool errorVisible;
  final bool isRequired;
  final int maxLength;

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
              border: Border.all(
                  color: isRequired == false
                      ? Color(0xFFB8B8B8)
                      : Color(0xFFD31145))),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validateFunc,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLength),
            ],
            onFieldSubmitted: onSubmitted,
            onSaved: onSaved,
            maxLines: 1,
            onChanged: onChange,
            textAlignVertical: TextAlignVertical.bottom,
            controller: formController,
            decoration: InputDecoration(
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 5, top: 10, bottom: 10),
                isDense: true,
                labelText: formLabel,
                labelStyle: TextStyle(
                    fontFamily: "Kano",
                    fontSize: 15,
                    color: Colors.black.withOpacity(0.5)),
                hintText: formLabel,
                hintStyle: TextStyle(
                    fontFamily: "Kano",
                    fontSize: 15,
                    color: Colors.black.withOpacity(0.5))),
            keyboardType: formInputType,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontFamily: "Kano",
            ),
          ),
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
                    "Error : $formLabel can't be empty",
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
