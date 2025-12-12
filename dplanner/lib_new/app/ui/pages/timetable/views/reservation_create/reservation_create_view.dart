import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../config/constants/app_colors.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_layout.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_view.dart';
import '../../../../base/widgets/buttons/rounded_rectangle_full_button.dart';
import '../../widgets/row/checkbox_row.dart';
import '../../widgets/row/color_selector_row.dart';
import '../../widgets/row/invitees_row.dart';
import '../../widgets/row/text_info_row.dart';
import '../../widgets/row/underline_textform_row.dart';
import 'reservation_create_view_controller.dart';

class ReservationCreateView extends BottomSheetView<ReservationCreateViewController> {
  const ReservationCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheetLayout(
      title: "예약하기",
      content: Obx(
        () => Column(
          children: [
            TextInfoRow(
                title: "예약 품목", content: controller.resourceName, contentColor: AppColors.textGray),
            TextInfoRow(
                title: "예약자",
                content: controller.reservationOwnerName,
                contentColor: controller.isManager ? AppColors.textBlack : AppColors.textGray,
                onTap: controller.isManager ? controller.changeReservationOwner : () {}),
            TextInfoRow(
                title: "예약 날짜",
                content: controller.reservationDate,
                onTap: controller.changeReservationTime),
            TextInfoRow(
                title: "예약 시간",
                content: controller.isTimeSelected ? controller.reservationTime : "예약 시간을 선택해 주세요",
                contentColor: controller.isTimeSelected ? AppColors.textBlack : AppColors.textGray,
                onTap: controller.changeReservationTime),
            ColorSelectorRow(
                title: "예약 색상",
                defaultColor: controller.reservationColor.value,
                onColorChanged: controller.changeReservationColor),
            UnderlineTextFormRow(
                title: "예약 제목(선택)",
                hintText: "예약 제목을 입력해 주세요",
                controller: controller.reservationTitleForm),
            UnderlineTextFormRow(
                title: "사용 용도(선택)",
                hintText: "사용 용도를 입력해 주세요",
                controller: controller.reservationUsageForm),
            InviteesRow(
                title: "함께 사용하는 사람(선택)",
                invitees: controller.reservationInvitees,
                onTap: controller.changeReservationInvitees),
            CheckboxRow(
                title: "다른 사람과 함께 사용할 수 있나요?",
                defaultValue: controller.reservationSharing.value,
                onChanged: controller.changeReservationSharing),
          ],
        ),
      ),
      buttons: [
        RoundedRectangleFullButton(title: "예약 신청하기", onTap: controller.createReservation),
      ],
    );
  }
}
