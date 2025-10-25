import 'package:flutter/material.dart';

import '../color_circle.dart';

class ColorInfoRow extends StatelessWidget {
  final String title;
  final Color color;

  const ColorInfoRow({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        ColorCircle(color: color, showBorder: true, borderWidth: 5.0)
      ]),
    );
  }
}
