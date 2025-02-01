import 'package:flutter/material.dart';

import '../../../../../config/constants/app_colors.dart';
import 'full_button_frame.dart';

class RoundedRectangleFullButton extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;
  final void Function()? onTap;
  final bool isLast;

  const RoundedRectangleFullButton(
      {super.key,
      required this.title,
      this.onTap,
      this.color = AppColors.primaryColor,
      this.textColor = AppColors.textWhite,
      this.isLast = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isLast ? const EdgeInsets.only(bottom: 16.0) : const EdgeInsets.all(0),
      child: FullButtonFrame(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: color,
            ),
            onPressed: onTap,
            child: Text(title,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(color: textColor))),
      ),
    );
  }
}
