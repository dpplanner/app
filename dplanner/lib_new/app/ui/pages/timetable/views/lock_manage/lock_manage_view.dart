import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../config/constants/app_colors.dart';
import '../../../../base/widgets/base_bottom_sheet_view.dart';
import '../../../../base/widgets/buttons/rounded_rectangle_half_button.dart';
import '../../widgets/legend_box.dart';
import '../../widgets/time_picker_date_header.dart';
import '../../widgets/time_picker_grid.dart';
import '../../widgets/row/half_button_row.dart';
import '../bottom_sheet_view.dart';
import 'lock_manage_view_controller.dart';

class LockManageView extends BottomSheetView<LockManageViewController> {
  const LockManageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheetView(
      title: controller.title,
      content: Obx(() {
        // 초기 로딩 중일 때는 같은 레이아웃에 로딩 인디케이터만 표시
        if (controller.isInitialLoading.value) {
          return SizedBox(
            width: double.infinity,
            height: 350, // 콘텐츠와 비슷한 높이 유지
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 네비게이션
            TimePickerDateHeader(
              selectedDate: controller.selectedDate.value,
              onPrev: () async => await controller.moveDate(-1),
              onNext: () async => await controller.moveDate(1),
              onCalendarTap: controller.changeDate,
            ),
            const SizedBox(height: 16),

            // 전체 선택 체크박스
            GestureDetector(
              onTap: controller.toggleSelectAll,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: controller.isAllSelected,
                      onChanged: (_) => controller.toggleSelectAll(),
                      activeColor: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "전체 선택",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 시간 그리드 (4x6)
            SizedBox(
              width: double.infinity,
              child: TimePickerGrid(
                timeSlots: controller.timeSlots
                    .map((slot) => slot.value)
                    .toList(),
                onTap: controller.toggleTimeSlot,
                availableColor: AppColors.bgPrimary,
                blockedColor: AppColors.subColor2,
                selectedColor: AppColors.lockColor,
                textColor: AppColors.textBlack,
                selectedTextColor: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 8),

            // 범례
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LegendBox(color: AppColors.bgPrimary, label: '예약 가능'),
                SizedBox(width: 12),
                LegendBox(color: AppColors.lockColor, label: '잠금'),
                SizedBox(width: 12),
                LegendBox(color: AppColors.subColor2, label: '예약됨'),
              ],
            ),
          ],
        );
      }),
      buttons: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Obx(() {
            final canSubmit =
                controller.hasChanges.value && !controller.isLoading.value;
            return HalfButtonRow(
              left: RoundedRectangleHalfButton(
                title: "취소",
                color: AppColors.subColor5,
                onTap: controller.cancel,
              ),
              right: RoundedRectangleHalfButton(
                title: "잠금 시간 수정",
                onTap: canSubmit ? controller.submitLockChanges : null,
              ),
            );
          }),
        ),
      ],
    );
  }
}
