import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/constants/app_colors.dart';
import '../../pages/timetable/views/bottom_sheet_view.dart';

class BottomSheetController extends GetxController {
  final RxList<BottomSheetView> _viewStack = <BottomSheetView>[].obs;

  Widget get currentView => _viewStack.isNotEmpty ? _viewStack.last : Container();

  bool canPop() => _viewStack.length > 1;

  void clear() {
    _viewStack.clear();
  }

  void pushView({required BottomSheetView view, Map<String, dynamic>? arguments}) {
    _viewStack.add(view);
    if (arguments != null) {
      view.controller.init(arguments);
    }
  }

  void popView() {
    if (canPop()) {
      _viewStack.removeLast();
    } else {
      Get.back(result: true);
    }
  }

  void changeView({required BottomSheetView view, Map<String, dynamic>? arguments}) {
    popView();
    pushView(view: view, arguments: arguments);
  }
}

Future bottomSheet({required BottomSheetView view, Map<String, dynamic>? arguments}) {
  final controller = Get.find<BottomSheetController>();
  controller.pushView(view: view, arguments: arguments);

  return Get.bottomSheet(
    Obx(() => controller.currentView),
    isScrollControlled: true,
    backgroundColor: AppColors.bgWhite,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    )
  ).then((value) {
    Future.delayed(Duration(milliseconds: 100), () => controller.clear());
    return value;
  });
}
