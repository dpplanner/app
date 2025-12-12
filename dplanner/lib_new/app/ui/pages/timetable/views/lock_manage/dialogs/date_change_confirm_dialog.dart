import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../config/constants/app_colors.dart';
import '../../../../../base/widgets/base_dialog_view.dart';
import '../../../../../base/widgets/buttons/simple_text_button.dart';

class DateChangeConfirmDialog extends StatelessWidget {
  const DateChangeConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseDialogView(
      title: "잠금 날짜",
      content: const Text(
        "날짜 변경시 지금까지의 변경사항이\n초기화됩니다.\n\n정말 변경하시겠습니까?",
        textAlign: TextAlign.center,
        style: TextStyle(height: 1.5),
      ),
      actions: [
        SimpleTextButton(
          buttonName: "취소",
          textColor: AppColors.textGray,
          onPressed: () => Get.back(result: false),
        ),
        SimpleTextButton(
          buttonName: "변경하기",
          textColor: AppColors.primaryColor,
          onPressed: () => Get.back(result: true),
        ),
      ],
    );
  }
}
