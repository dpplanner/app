import 'package:get/get.dart';

import 'club_find_controller.dart';

class ClubFindBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubFindController>(() => ClubFindController());
  }
}
