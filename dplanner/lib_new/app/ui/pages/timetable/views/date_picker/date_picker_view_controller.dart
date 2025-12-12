import 'package:get/get.dart';

import '../../../../../utils/datetime_utils.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_navigator.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_view_controller.dart';
import '../../../../base/widgets/snackbar.dart';

class DatePickerViewController extends BottomSheetViewController {
  final BottomSheetNavigator _navigator = Get.find<BottomSheetNavigator>();
  late Rx<DateTime> selectedDate = DateTime.now().obs;
  DateTime? rangeStartDate;
  DateTime? rangeEndDate;
  Function(DateTime)? onSelected;

  @override
  void reset() {
    selectedDate.value = DateTime.now();
    rangeStartDate = null;
    rangeEndDate = null;
    onSelected = null;
  }

  @override
  void init(Map<String, dynamic> arguments) {
    selectedDate = arguments.containsKey("selectedDate")
        ? (arguments["selectedDate"] as DateTime).obs
        : DateTime.now().obs;

    if (arguments.containsKey("availableRange")) {
      rangeStartDate = arguments["availableRange"]["start"];
      rangeEndDate = arguments["availableRange"]["end"];
    } else {
      rangeStartDate = null;
      rangeEndDate = null;
    }

    if (arguments.containsKey("onSelected")) {
      onSelected = arguments["onSelected"];
    }
  }

  void onDaySelected(DateTime newSelectedDate, DateTime newFocusedDate) {
    if ((rangeStartDate == null && rangeEndDate == null) ||
        newSelectedDate.isWithin(rangeStartDate!, rangeEndDate!)) {
      selectedDate.value = newSelectedDate;
    } else {
      snackBar(title: "선택할 수 없는 날짜입니다", content: "선택 가능한 날짜를 선택해주세요");
    }
  }

  void onTap() {
    onSelected?.call(selectedDate.value);
    _navigator.popView();
  }
}
