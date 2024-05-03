import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../style.dart';

void snackBar({required String title, required String content}) {
  // 기존 스낵바 닫기
  if (Get.isSnackbarOpen) {
    Get.closeCurrentSnackbar();
  }

  Get.snackbar(title, content,
      borderRadius: 24,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      colorText: AppColor.backgroundColor,
      backgroundColor: AppColor.subColor3,
      snackPosition: SnackPosition.TOP,
      animationDuration: const Duration(milliseconds: 200),
      isDismissible: true);
}
