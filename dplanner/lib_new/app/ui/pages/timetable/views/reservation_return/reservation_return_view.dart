import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../base/widgets/base_bottom_sheet_view.dart';
import '../../../../base/widgets/buttons/rounded_rectangle_full_button.dart';
import '../../widgets/row/image_picker_row.dart';
import '../../widgets/row/outline_textform_row.dart';
import '../../widgets/row/text_info_row.dart';
import '../bottom_sheet_view.dart';
import 'reservation_return_view_controller.dart';

class ReservationReturnView extends BottomSheetView<ReservationReturnViewController> {
  const ReservationReturnView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheetView(
        title: "반납하기",
        content: Column(
          children: [
            TextInfoRow(title: "예약 품목", content: controller.resourceName),
            ImagePickerRow(
              title: "반납 사진",
              limit: 5,
              selectedImages: controller.returnImages,
              onChanged: controller.onImageChanged,
            ),
            OutlineTextFormRow(
              title: '반납 메시지(선택)',
              hintText: '추가 설명이 필요할 경우 작성해주세요',
              controller: controller.returnMessageForm,
            )
          ],
        ),
        buttons: [RoundedRectangleFullButton(title: "반납하기", onTap: controller.returnReservation)]);
  }
}
