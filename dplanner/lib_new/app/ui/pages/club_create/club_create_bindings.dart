import 'package:get/get.dart';

import 'club_create_controller.dart';

class ClubCreateBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubCreateController>(() => ClubCreateController());
  }
}
