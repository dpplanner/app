import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../config/constants/app_colors.dart';

void snackBar({required String title, required String content}) {
  // 기존 스낵바 닫기
  if (Get.isSnackbarOpen) {
    Get.closeCurrentSnackbar();
  }

  Get.snackbar(title, content,
      borderRadius: 8,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      colorText: AppColors.textBlack,
      backgroundColor: AppColors.subColor2.withOpacity(0.85),
      snackPosition: SnackPosition.TOP,
      animationDuration: const Duration(milliseconds: 600),
      duration: const Duration(milliseconds: 1500),
      isDismissible: true);
}