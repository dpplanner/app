import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import '../../../../../config/constants/app_colors.dart';

class CustomFloatingActionButton extends StatefulWidget {
  final Map<IconData, VoidCallback>? actions;
  final IconData? iconData;
  final VoidCallback? onPressed;
  final bool isMulti;

  // 싱글 FAB 생성자
  const CustomFloatingActionButton.single({
    super.key,
    required this.iconData,
    required this.onPressed,
  })  : isMulti = false,
        actions = null;

  // 멀티 FAB 생성자
  const CustomFloatingActionButton.multi({
    super.key,
    required this.actions,
  })  : isMulti = true,
        iconData = null,
        onPressed = null;

  @override
  State<CustomFloatingActionButton> createState() => _CustomFloatingActionButton();
}

class _CustomFloatingActionButton extends State<CustomFloatingActionButton> {
  bool isExpanded = false;

  void toggleExpand() => setState(() => isExpanded = !isExpanded);

  @override
  Widget build(BuildContext context) {
    return widget.isMulti ? _buildMultiFAB() : _buildSingleFAB();
  }

  // 싱글 FAB 렌더링
  Widget _buildSingleFAB() {
    return FloatingActionButton(
      onPressed: widget.onPressed,
      child: Icon(widget.iconData, size: 24, color: AppColors.bgWhite),
    );
  }

  // 멀티 FAB 렌더링
  Widget _buildMultiFAB() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isExpanded)
          ...widget.actions!.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: FloatingActionButton.small(
                onPressed: entry.value,
                child: Icon(entry.key, size: 24, color: AppColors.bgWhite),
              ),
            );
          }),
        FloatingActionButton.large(
          onPressed: toggleExpand,
          child: Icon(isExpanded ? SFSymbols.chevron_down : SFSymbols.chevron_up,
              size: 24, color: AppColors.bgWhite),
        ),
      ],
    );
  }
}
