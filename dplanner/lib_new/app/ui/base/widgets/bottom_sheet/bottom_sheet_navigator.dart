import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../config/constants/app_colors.dart';
import 'bottom_sheet_view.dart';

class BottomSheetNavigator extends GetxController {
  final RxList<BottomSheetView> _viewStack = <BottomSheetView>[].obs;

  Widget get currentView => _viewStack.isNotEmpty ? _viewStack.last : Container();

  bool canPop() => _viewStack.length > 1;

  /// 바텀시트 열기 (진입점)
  Future<dynamic> open({
    required BottomSheetView view,
    Map<String, dynamic>? arguments,
  }) {
    pushView(view: view, arguments: arguments);

    return Get.bottomSheet(
      Obx(() => currentView),
      isScrollControlled: true,
      backgroundColor: AppColors.bgWhite,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
    ).then((value) {
      Future.delayed(const Duration(milliseconds: 100), () => clear());
      return value;
    });
  }

  /// 스택에 뷰 추가 (내부 네비게이션)
  void pushView({required BottomSheetView view, Map<String, dynamic>? arguments}) {
    _viewStack.add(view);
    view.controller.reset();
    if (arguments != null) {
      view.controller.init(arguments);
    }
  }

  /// 스택에서 뷰 제거 (뒤로가기)
  void popView() {
    if (canPop()) {
      _viewStack.removeLast();
    } else {
      close();
    }
  }

  /// 바텀시트 완전 종료
  void close({bool success = true}) {
    Get.back(result: success);
  }

  /// 스택 초기화
  void clear() {
    _viewStack.clear();
  }
}
