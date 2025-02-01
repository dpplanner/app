import 'package:flutter/material.dart';

import '../../../../config/constants/app_colors.dart';

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
    const markedUnderline =
        UnderlineInputBorder(borderSide: BorderSide(color: AppColors.markColor, width: 2));

    var defaultUnderline = UnderlineInputBorder(
      borderSide: BorderSide(
          color:
              noLine ? Colors.transparent : (isFocused ? AppColors.textBlack : AppColors.textGray)),
    );

    return TextFormField(
      style: Theme.of(context).textTheme.bodyLarge,
      textInputAction: TextInputAction.done,
      textAlign: isRight ? TextAlign.end : TextAlign.start,
      keyboardType: keyboardType,
      controller: controller,
      maxLength: maxLength != 0 ? maxLength : null,
      enabled: isWritten ? false : true,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.textGray),
        errorStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.markColor),
        disabledBorder: defaultUnderline,
        enabledBorder: defaultUnderline,
        focusedBorder: defaultUnderline,
        errorBorder: markedUnderline,
        focusedErrorBorder: markedUnderline,
        contentPadding: const EdgeInsets.fromLTRB(4.0, 12.0, 4.0, 0.0),
      ),
    );
  }
}
