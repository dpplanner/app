import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';

import '../../../../../../config/constants/app_colors.dart';
import '../../../../base/widgets/base_bottom_sheet_view.dart';
import '../../../../base/widgets/buttons/rounded_rectangle_full_button.dart';
import '../../widgets/date_picker.dart';
import '../../widgets/legend_box.dart';
import '../../widgets/time_picker_date_header.dart';
import '../../widgets/time_picker_grid.dart';
import '../bottom_sheet_view.dart';
import '../error/error_view.dart';
import '../loading/loading_view.dart';
import 'reservation_time_picker_view_controller.dart';

class ReservationTimePickerView extends BottomSheetView<ReservationTimePickerViewController> {
  const ReservationTimePickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.initSlots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return BottomSheetErrorView(title: controller.title);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return BottomSheetLoadingView(title: controller.title);
          }
          return BaseBottomSheetView(
            title: controller.title,
            content: Obx(() => Column(children: [
                  TimePickerDateHeader(
                      selectedDate: controller.selectedDate.value,
                      onPrev: () async => await controller.moveDate(-1),
                      onNext: () async => await controller.moveDate(1),
                      onCalendarTap: controller.changeDate),
                  TimePickerGrid(
                    timeSlots: controller.timeSlots.map((slot) => slot.value).toList(),
                    onTap: controller.toggleTimeSlot,
                    availableColor: AppColors.bgPrimary,
                    blockedColor: AppColors.lockColor,
                    selectedColor: AppColors.primaryColor,
                    textColor: AppColors.textBlack,
                    selectedTextColor: AppColors.textWhite,
                  ),
                  const SizedBox(height: 8),
                  const Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    LegendBox(color: AppColors.bgPrimary, label: '선택 가능'),
                    SizedBox(width: 16),
                    LegendBox(color: AppColors.lockColor, label: '선택 불가')
                  ])
                ])),
            buttons: [
              Obx(() => RoundedRectangleFullButton(
                  title: "선택 완료",
                  onTap: controller.isSelected ? controller.selectReservationTime : null))
            ],
          );
        });
  }
}
