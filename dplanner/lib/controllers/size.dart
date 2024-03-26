import 'package:get/get.dart';

class SizeController extends GetxController {
  static SizeController get to => Get.find();

  double screenWidth = 0;
  double screenHeight = 0;
  bool checkAdminButton = false;

  void clickedButton() {
    checkAdminButton = !checkAdminButton;
    update();
  }
}
