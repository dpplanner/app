import 'package:flutter/cupertino.dart';

import '../../../../../config/constants/app_colors.dart';

class LegendBox extends StatelessWidget {
  final Color color;
  final String label;

  const LegendBox({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        SizedBox(width: 6),
        Text(label)
      ],
    );
  }
}
