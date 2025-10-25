import 'package:dplanner/widgets/underline_textform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../config/constants/app_colors.dart';
import '../../../../../../data/model/reservation/reservation.dart';
import '../../../../../base/widgets/base_dialog_view.dart';
import '../../../../../base/widgets/buttons/simple_text_button.dart';

class RejectDialogView extends StatelessWidget {
  const RejectDialogView({super.key});

  @override
  Widget build(BuildContext context) {
    Reservation reservation = Get.arguments["reservation"];
    final TextEditingController rejectMessageForm = TextEditingController();

    return BaseDialogView(
        title: "예약 거절",
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: const Text("거절 사유를 작성해 주세요."),
            ),
            UnderlineTextForm(
                hintText: "ex) 공간 정비 시간입니다.", controller: rejectMessageForm, fontSize: 14)
          ],
        ),
        actions: [
          SimpleTextButton(
              buttonName: "닫기",
              textColor: AppColors.textGray,
              onPressed: () => Get.back(result: false)),
          SimpleTextButton(
              buttonName: "거절하기",
              textColor: AppColors.primaryColor,
              onPressed: () {
                reservation.rejectMessage = rejectMessageForm.text;
                Get.back(result: true);
              })
        ]);
  }
}
