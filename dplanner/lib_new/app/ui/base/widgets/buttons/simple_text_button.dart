import 'package:flutter/material.dart';

class SimpleTextButton extends StatelessWidget {
  final String buttonName;
  final Color textColor;
  final VoidCallback? onPressed;

  const SimpleTextButton(
      {super.key, required this.buttonName, required this.textColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Text(buttonName,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: textColor)));
  }
}
