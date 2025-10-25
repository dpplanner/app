import 'package:get/get.dart';

import 'bottom_sheet_view_controller.dart';

abstract class BottomSheetView<T  extends BottomSheetViewController> extends GetView<T> {
  const BottomSheetView({super.key});

  @override
  T get controller => Get.find<T>();
}