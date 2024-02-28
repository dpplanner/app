import 'package:get/get.dart';

import '../style.dart';

void snackBar({required String title, required String content}) {
  Get.snackbar(title, content,
      colorText: AppColor.textColor,
      backgroundColor: AppColor.backgroundColor,
      snackPosition: SnackPosition.BOTTOM);
}
