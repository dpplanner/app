import 'package:get/get.dart';

class ClubController extends GetxController {
  static ClubController get to => Get.find();

  RxString name = ''.obs;
  RxString content = ''.obs;
}
