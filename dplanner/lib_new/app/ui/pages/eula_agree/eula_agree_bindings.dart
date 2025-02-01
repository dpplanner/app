import 'package:get/get.dart';

import 'eula_agree_controller.dart';

class EulaAgreeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EulaAgreeController>(() => EulaAgreeController());
  }
}