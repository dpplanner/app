import 'package:flutter/material.dart';

import '../../../../../../config/constants/app_colors.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_layout.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_view.dart';
import '../../../../base/widgets/buttons/rounded_rectangle_full_button.dart';
import '../../../../base/widgets/buttons/rounded_rectangle_half_button.dart';
import '../../widgets/row/accordian_row.dart';
import '../../widgets/row/color_info_row.dart';
import '../../widgets/row/half_button_row.dart';
import '../../widgets/row/image_info_row.dart';
import '../../widgets/row/longtext_info_row.dart';
import '../../widgets/row/text_info_row.dart';
import 'reservation_info_view_controller.dart';

class ReservationInfoView extends BottomSheetView<ReservationInfoViewController> {
  const ReservationInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheetLayout(
      title: controller.title,
      content: Column(
        children: [
          TextInfoRow(title: "예약 상태", content: controller.reservationStatus),
          TextInfoRow(title: "예약자", content: controller.reservationOwnerName),
          TextInfoRow(title: "예약 날짜", content: controller.reservationDate),
          TextInfoRow(title: "예약 시간", content: controller.reservationTime),
          ColorInfoRow(title: "예약 색상", color: controller.reservationColor),
          TextInfoRow(title: "물품 공유 여부", content: controller.shareInfo),
          if (controller.hasAdditionalInfo())
            AccordionRow(title: "예약 정보 더보기", children: [
              if (controller.reservation.hasTitle())
                TextInfoRow(title: "예약 제목", content: controller.reservationTitle),
              if (controller.reservation.hasUsage())
                TextInfoRow(title: "사용 용도", content: controller.reservationUsage),
              if (controller.reservation.hasInvitees())
                TextInfoRow(title: "함께 사용하는 사람", content: controller.reservationInvitees),
            ]),
          if (controller.hasReturnInfo() && controller.hasAuthority())
            AccordionRow(title: "반납 정보 보기", children: [
              if (controller.reservation.hasReturnImages())
                ImageInfoRow(title: "반납 사진", imageUrls: controller.returnImageUrls),
              if (controller.reservation.hasReturnMessage())
                LongTextInfoRow(title: "반납 메시지", content: controller.returnMessage)
            ])
        ],
      ),
      buttons: [
        if (controller.requireReturn())
          RoundedRectangleFullButton(
              title: "반납하기",
              onTap: controller.toReturnReservationView,
              isLast: !controller.isHalfButtonRowVisible()),
        if (controller.isHalfButtonRowVisible())
          if (controller.isConfirmable())
            HalfButtonRow(
                left: RoundedRectangleHalfButton(
                    title: "거절하기", color: AppColors.subColor3, onTap: controller.rejectReservation),
                right:
                    RoundedRectangleHalfButton(title: "승인하기", onTap: controller.confirmReservation))
          else if (controller.isDeletable())
            HalfButtonRow(
                left: RoundedRectangleHalfButton(
                    title: "예약 삭제",
                    color: AppColors.markColor,
                    onTap: controller.deleteReservation),
                right:
                    RoundedRectangleHalfButton(title: "예약 수정", onTap: controller.modifyReservation))
          else if (controller.isCancelable())
            HalfButtonRow(
                left: RoundedRectangleHalfButton(
                    title: "예약 취소",
                    color: AppColors.subColor3,
                    onTap: controller.cancelReservation),
                right:
                    RoundedRectangleHalfButton(title: "예약 수정", onTap: controller.modifyReservation))
      ],
    );
  }
}
