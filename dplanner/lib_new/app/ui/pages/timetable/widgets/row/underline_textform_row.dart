import 'package:flutter/material.dart';

import '../../../../base/widgets/underline_textform.dart';

class UnderlineTextFormRow extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final String? content;

  const UnderlineTextFormRow({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: UnderlineTextForm(
                  hintText: hintText,
                  controller: controller,
                  isRight: true,
                  noLine: true,
                  noErrorSign: true,
                  isDense: true))
        ],
      ),
    );
  }
}
