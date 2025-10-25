import 'package:flutter/material.dart';

import '../../../../base/widgets/outline_textform.dart';

class OutlineTextFormRow extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;

  const OutlineTextFormRow(
      {super.key, required this.title, required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: OutlineTextForm(
                hintText: hintText,
                controller: controller,
                maxLines: 5,
              ))
        ]),
      ),
    );
  }
}
