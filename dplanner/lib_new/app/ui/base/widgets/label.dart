import 'package:flutter/material.dart';

import '../../../../config/constants/app_colors.dart';

class Label extends StatelessWidget {
  final String label;

  const Label(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.subColor1,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textWhite)));
  }
}
