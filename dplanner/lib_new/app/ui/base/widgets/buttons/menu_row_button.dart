import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import '../../../../../config/constants/app_colors.dart';

class MenuRowButton extends StatelessWidget {
  final String title;
  final void Function()? onTap;

  const MenuRowButton({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textBlack,
          backgroundColor: AppColors.bgWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            const Icon(SFSymbols.chevron_right),
          ],
        ),
    );
  }
}