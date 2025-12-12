import 'package:flutter/material.dart';

class CheckboxRow extends StatelessWidget {
  final String title;
  final bool defaultValue;
  final ValueChanged<bool?>? onChanged;

  const CheckboxRow({
    super.key,
    required this.title,
    required this.defaultValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Checkbox(value: defaultValue, onChanged: onChanged)
        ],
      ),
    );
  }
}
