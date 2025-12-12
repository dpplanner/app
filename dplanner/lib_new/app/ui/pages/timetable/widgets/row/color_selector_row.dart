import 'package:flutter/material.dart';

import '../../../../../../config/constants/app_colors.dart';
import '../color_selector.dart';

class ColorSelectorRow extends StatelessWidget {
  final String title;
  final Color defaultColor;
  final ValueChanged<Color> onColorChanged;

  const ColorSelectorRow(
      {super.key, required this.title, required this.defaultColor, required this.onColorChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        ColorSelector(
            defaultColor: defaultColor,
            availableColors: ReservationColors.reservationColors,
            onColorChanged: onColorChanged)
      ]),
    );
  }
}
