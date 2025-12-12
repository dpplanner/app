import 'package:flutter/material.dart';

import '../../../../../../config/constants/app_colors.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_layout.dart';

class BottomSheetErrorView extends StatelessWidget {
  final String title;

  const BottomSheetErrorView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return BottomSheetLayout(
        title: title,
        content: Column(
          children: [
            const SizedBox(height: 160),
            Icon(Icons.error_outline, size: 64, color: AppColors.markColor),
            const SizedBox(height: 16),
            Text(
              "데이터를 불러오지 못했어요",
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "잠시 후 다시 시도해 주세요.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textGray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        buttons: []);
  }

}