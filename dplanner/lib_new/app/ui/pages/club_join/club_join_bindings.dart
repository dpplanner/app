import 'package:get/get.dart';

import 'club_join_controller.dart';

class ClubJoinBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubJoinController>(() => ClubJoinController());
  }
}
