import 'package:get/get.dart';

import 'club_create_success_controller.dart';

class ClubCreateSuccessBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubCreateSuccessController>(() => ClubCreateSuccessController());
  }
}
