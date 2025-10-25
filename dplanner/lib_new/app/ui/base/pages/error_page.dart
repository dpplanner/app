import 'package:flutter/material.dart';

import '../../../../config/constants/app_colors.dart';

class ErrorPage extends StatelessWidget {
  final BoxConstraints constraints;
  const ErrorPage({super.key, this.constraints = const BoxConstraints()});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 240),
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
        ));
  }
}