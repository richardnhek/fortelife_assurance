import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/utils/device_utils.dart';

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
      this.maxLength,
      this.appProvider,
      this.mq});

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
  final AppProvider appProvider;
  final MediaQueryData mq;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color:
                  isRequired == false ? Color(0xFFB8B8B8) : Color(0xFFD31145))),
      child: Center(
        child: TextFormField(
          textCapitalization: TextCapitalization.words,
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
              contentPadding: EdgeInsets.only(left: 5, bottom: 5),
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
    );
  }
}
