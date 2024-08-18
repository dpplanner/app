
import 'package:flutter/cupertino.dart';

import '../const/style.dart';

class ColorUnitWidget extends StatelessWidget {
  static const double circleSize = 24.0;

  final Color color;
  final bool showBorder;
  final double borderWidth;

  const ColorUnitWidget({
    super.key,
    required this.color,
    required this.showBorder,
    required this.borderWidth});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: showBorder
              ? Border.all(
              color: AppColor.backgroundColor2,
              width: borderWidth)
              : null
      ),
    );
  }

}