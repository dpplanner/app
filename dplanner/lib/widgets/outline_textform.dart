import 'package:flutter/material.dart';

import '../const/style.dart';

class OutlineTextForm extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isFocused;
  final bool isColored;
  final Color hintTextColor;
  final int maxLines;
  final bool expandable;
  final bool noLine;
  final double fontSize;
  final Widget icon;
  final bool isEnabled;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;

  const OutlineTextForm(
      {super.key,
      required this.hintText,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.isFocused = false,
      this.isColored = false,
      this.hintTextColor = AppColor.textColor2,
      this.maxLines = 1,
      this.expandable = false,
      this.noLine = false,
      this.fontSize = 16,
      this.icon = const Icon(Icons.arrow_forward),
      this.isEnabled = true,
      this.validator,
      this.onSaved,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //textInputAction: TextInputAction.done,
      controller: controller,
      minLines: maxLines,
      maxLines: expandable ? null : maxLines,
      enabled: isEnabled,
      decoration: InputDecoration(
        suffixIcon: (isColored) ? icon : null,
        fillColor: AppColor.backgroundColor2,
        filled: (isColored) ? true : false,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          color: hintTextColor,
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: noLine || isColored
                    ? Colors.transparent
                    : (isFocused ? AppColor.textColor : AppColor.textColor2)),
            borderRadius: BorderRadius.circular(15.0)),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: noLine || isColored
                    ? Colors.transparent
                    : (isFocused ? AppColor.textColor : AppColor.textColor2)),
            borderRadius: BorderRadius.circular(15.0)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: noLine || isColored
                  ? Colors.transparent
                  : (isFocused ? AppColor.textColor : AppColor.textColor2)),
          borderRadius: BorderRadius.circular(15.0),
        ),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: AppColor.markColor,
                width: 2,
                strokeAlign: BorderSide.strokeAlignOutside),
            borderRadius: BorderRadius.circular(15.0)),
        errorStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColor.markColor,
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColor.markColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15.0)),
        contentPadding: const EdgeInsets.all(10.0),
      ),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: AppColor.textColor,
      ),
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
    );
  }
}
