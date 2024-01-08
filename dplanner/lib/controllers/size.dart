import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SizeController extends GetxController {
  RxDouble screenWidth = MediaQuery.of(Get.context!).size.width.obs;
  RxDouble screenHeight = MediaQuery.of(Get.context!).size.height.obs;

  RxDouble bigFontSize = (MediaQuery.of(Get.context!).size.width * 0.07).obs;
  RxDouble middleFontSize = (MediaQuery.of(Get.context!).size.width * 0.04).obs;
  RxDouble smallFontSize = (MediaQuery.of(Get.context!).size.width * 0.02).obs;
}
