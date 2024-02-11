import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';

class NextPageButton extends StatelessWidget {
  final Color buttonColor;
  final VoidCallback onPressed;
  final Widget text;

  const NextPageButton(
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
          minimumSize: Size(SizeController.to.screenWidth * 0.9,
              SizeController.to.screenHeight * 0.05), //width, height
        ),
        onPressed: onPressed,
        child: text);
  }
}
