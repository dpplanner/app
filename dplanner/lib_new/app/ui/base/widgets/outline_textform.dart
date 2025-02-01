import 'package:flutter/material.dart';

import '../../../../config/constants/app_colors.dart';

class OutlineTextForm extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isFocused;
  final bool isColored;
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
    var defaultOutline = OutlineInputBorder(
        borderSide: BorderSide(
            color: noLine || isColored
                ? Colors.transparent
                : (isFocused ? AppColors.textBlack : AppColors.textGray)),
        borderRadius: BorderRadius.circular(8.0));

    var markedOutline = OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.markColor, width: 2),
        borderRadius: BorderRadius.circular(8.0));

    return TextFormField(
      style: Theme.of(context).textTheme.bodyLarge,
      textInputAction: TextInputAction.done,
      controller: controller,
      minLines: maxLines,
      maxLines: expandable ? null : maxLines,
      enabled: isEnabled,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      decoration: InputDecoration(
        suffixIcon: (isColored) ? icon : null,
        fillColor: AppColors.bgPrimary,
        filled: (isColored) ? true : false,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.textGray),
        errorStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.markColor),
        enabledBorder: defaultOutline,
        disabledBorder: defaultOutline,
        focusedBorder: defaultOutline,
        errorBorder: markedOutline,
        focusedErrorBorder: markedOutline,
        contentPadding: const EdgeInsets.all(8.0),
      ),
    );
  }
}
