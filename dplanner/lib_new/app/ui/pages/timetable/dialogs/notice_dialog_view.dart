import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../config/constants/app_colors.dart';
import '../../../base/widgets/base_dialog_view.dart';
import '../../../base/widgets/buttons/simple_text_button.dart';

class NoticeDialogView extends StatelessWidget {
  final String notice;

  const NoticeDialogView({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return BaseDialogView(
        title: "주의 사항",
        content: Text(
          notice,
          textAlign: TextAlign.center,
          style: TextStyle(height: 1.5),
        ),
        actions: [
          SimpleTextButton(
              buttonName: "닫기",
              textColor: AppColors.textGray,
              onPressed: () => Get.back(result: false)),
          SimpleTextButton(
              buttonName: "확인",
              textColor: AppColors.primaryColor,
              onPressed: () => Get.back(result: true))
        ]);
  }
}
