import 'package:flutter/material.dart';

import 'buttons/simple_text_button.dart';

class BaseDialogView extends StatelessWidget {
  final String title;
  final Widget content;
  final List<SimpleTextButton> actions;
  final MainAxisAlignment? actionsAlignment;

  const BaseDialogView(
      {super.key,
      required this.title,
      required this.content,
      required this.actions,
      this.actionsAlignment = MainAxisAlignment.spaceBetween});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(title)),
      content: SingleChildScrollView(child: SizedBox(width: 280, child: content)),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      actions: actions,
      actionsAlignment: actionsAlignment,
      actionsPadding: const EdgeInsets.only(top: 0, bottom: 16, right: 16, left: 16),
    );
  }
}
