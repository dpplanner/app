import 'package:flutter/material.dart';
import '../../../../../../config/constants/app_colors.dart';

class TextInfoRow extends StatelessWidget {
  final String title;
  final String content;
  final Color contentColor;
  final VoidCallback? onTap;

  const TextInfoRow({
    super.key,
    required this.title,
    required this.content,
    this.contentColor = AppColors.textBlack,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          GestureDetector(
              onTap: onTap,
              child: Text(content,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: contentColor)))
        ],
      ),
    );
  }
}
