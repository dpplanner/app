import 'package:flutter/material.dart';

import '../../../../config/constants/app_colors.dart';
import '../widgets/base_appbar.dart';
import '../widgets/padded_safe_area.dart';

class SimpleInfoPage extends StatelessWidget {
  final String title;
  final String info;

  const SimpleInfoPage({super.key, required this.title, required this.info});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      appBar: BaseAppBar(
        leadingType: LeadingType.BACK,
        title: Text(title),
      ),
      body: PaddedSafeArea(
        child: SingleChildScrollView(
          child: Text(info, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
    );
  }
}
