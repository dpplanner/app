import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';

import '../../../../base/widgets/base_bottom_sheet_view.dart';
import '../../../../base/widgets/buttons/rounded_rectangle_full_button.dart';
import '../../widgets/date_picker.dart';
import '../bottom_sheet_view.dart';
import 'date_picker_view_controller.dart';

class DatePickerView extends BottomSheetView<DatePickerViewController> {
  const DatePickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheetView(
      title: "날짜 선택",
      content: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text("변경할 날짜를 선택해주세요", style: Theme.of(context).textTheme.bodyLarge)),
          Obx(() => DatePicker(
              selectedDay: controller.selectedDate.value,
              onDaySelected: controller.onDaySelected,
              rangeStartDate: controller.rangeStartDate,
              rangeEndDate: controller.rangeEndDate)),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Center(
              child: Obx(
                () => Text(
                    "선택한 날짜: ${DateFormat("yyyy년 MM월 dd일 E요일", 'ko_KR').format(controller.selectedDate.value)}",
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
          ),
        ],
      ),
      buttons: [
        RoundedRectangleFullButton(
          title: "선택완료",
          onTap: controller.onTap,
        )
      ],
    );
  }
}
