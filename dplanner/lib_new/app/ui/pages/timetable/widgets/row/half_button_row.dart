import 'package:flutter/cupertino.dart';

import '../../../../base/widgets/buttons/rounded_rectangle_half_button.dart';

class HalfButtonRow extends StatelessWidget {
  final RoundedRectangleHalfButton left;
  final RoundedRectangleHalfButton right;

  const HalfButtonRow({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [left, right]
    );
  }
}