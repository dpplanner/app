import 'package:get/get.dart';

import 'club_join_success_controller.dart';

class ClubJoinSuccessBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubJoinSuccessController>(() => ClubJoinSuccessController());
  }
}
