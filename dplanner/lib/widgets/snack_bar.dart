import 'package:get/get.dart';

import '../style.dart';

void snackBar({required String title, required String content}) {
  // 기존 스낵바 닫기
  if (Get.isSnackbarOpen) {
    Get.closeCurrentSnackbar();
  }

  Get.snackbar(title, content,
      colorText: AppColor.textColor,
      backgroundColor: AppColor.backgroundColor,
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: const Duration(milliseconds: 200),
      isDismissible: true);
}
