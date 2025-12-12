import 'package:flutter/material.dart';

import '../../../../base/widgets/bottom_sheet/bottom_sheet_layout.dart';

class BottomSheetLoadingView extends StatelessWidget {
  final String title;

  const BottomSheetLoadingView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return BottomSheetLayout(
        title: title,
        content: Column(children: [const SizedBox(height: 240), const CircularProgressIndicator()]),
        buttons: []);
  }
}
