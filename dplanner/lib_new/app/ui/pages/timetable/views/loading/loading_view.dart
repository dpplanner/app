import 'package:flutter/material.dart';

import '../../../../../../config/constants/app_colors.dart';
import '../../../../base/widgets/base_bottom_sheet_view.dart';

class BottomSheetLoadingView extends StatelessWidget {
  final String title;

  const BottomSheetLoadingView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheetView(
        title: title,
        content: Column(children: [const SizedBox(height: 240), const CircularProgressIndicator()]),
        buttons: []);
  }
}
