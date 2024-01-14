import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';

class NextPageButton extends StatelessWidget {
  final String name;
  final Color buttonColor;
  final VoidCallback onPressed;

  NextPageButton(
      {super.key,
      required this.name,
      required this.buttonColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: buttonColor,
        minimumSize: Size(SizeController.to.screenWidth * 0.9,
            SizeController.to.screenHeight * 0.05), //width, height
      ),
      onPressed: onPressed,
      child: Text(
        name,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColor.backgroundColor),
      ),
    );
  }
}
