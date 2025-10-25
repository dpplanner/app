import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../config/constants/app_colors.dart';
import '../../../../../base/widgets/base_dialog_view.dart';
import '../../../../../base/widgets/buttons/simple_text_button.dart';

class CancelDialogView extends StatelessWidget {
  const CancelDialogView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseDialogView(
        title: "예약 취소",
        content: const Text(
          "한번 취소한 예약은 되살릴 수 없습니다.\n정말 취소하시겠습니까?",
          textAlign: TextAlign.center,
          style: TextStyle(height: 1.5),
        ),
        actions: [
          SimpleTextButton(
              buttonName: "닫기",
              textColor: AppColors.textGray,
              onPressed: () => Get.back(result: false)),
          SimpleTextButton(
              buttonName: "취소하기",
              textColor: AppColors.primaryColor,
              onPressed: () => Get.back(result: true))
        ]);
  }
}
