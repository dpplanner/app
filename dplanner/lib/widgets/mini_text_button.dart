import 'package:flutter/material.dart';

class MiniTextButton extends StatelessWidget {
  final Color buttonColor;
  final VoidCallback onPressed;
  final Widget text;

  const MiniTextButton(
      {super.key,
      required this.buttonColor,
      required this.onPressed,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: buttonColor,

          minimumSize: const Size(0, 32),

          padding: const EdgeInsets.symmetric(
              vertical: 0.0, horizontal: 10.0), // 여기서 간격을 조절
        ),
        onPressed: onPressed,
        child: text);
  }
}
