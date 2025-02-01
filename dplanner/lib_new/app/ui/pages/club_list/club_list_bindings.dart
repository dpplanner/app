import 'package:get/get.dart';

import 'club_list_controller.dart';

class ClubListBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubListController>(() => ClubListController());
  }
}
