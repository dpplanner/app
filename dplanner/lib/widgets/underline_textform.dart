import 'package:flutter/material.dart';

import '../style.dart';

class UnderlineTextForm extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isFocused;
  final bool isWritten;
  final int maxLength;
  final bool noLine;
  final bool isRight;
  final bool noErrorSign;
  final double fontSize;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;

  const UnderlineTextForm(
      {super.key,
      required this.hintText,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.isFocused = false,
      this.isWritten = false,
      this.maxLength = 0,
      this.noLine = false,
      this.isRight = false,
      this.noErrorSign = false,
      this.fontSize = 16.0,
      this.validator,
      this.onSaved,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: isRight ? TextAlign.end : TextAlign.start,
      controller: controller,
      maxLength: maxLength != 0 ? maxLength : null,
      enabled: isWritten ? false : true,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          color: AppColor.textColor2,
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: noLine
                  ? Colors.transparent
                  : (isFocused ? AppColor.textColor : AppColor.textColor2)),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: noLine
                  ? Colors.transparent
                  : (isFocused ? AppColor.textColor : AppColor.textColor2)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: noLine
                  ? Colors.transparent
                  : (isFocused ? AppColor.textColor : AppColor.textColor2)),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
              color: AppColor.markColor,
              width: 2,
              strokeAlign: BorderSide.strokeAlignOutside),
        ),
        errorStyle: TextStyle(
          fontSize: noErrorSign ? 0 : 12,
          fontWeight: FontWeight.w400,
          color: AppColor.markColor,
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColor.markColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 5.0),
      ),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: AppColor.textColor,
      ),
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
    );
  }
}
