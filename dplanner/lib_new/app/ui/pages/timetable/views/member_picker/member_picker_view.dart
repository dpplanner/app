import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/widgets/bottom_sheet/bottom_sheet_layout.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_view.dart';
import '../../../../base/widgets/buttons/rounded_rectangle_full_button.dart';
import '../../widgets/row/member_picker_row.dart';
import '../error/error_view.dart';
import '../loading/loading_view.dart';
import 'member_picker_view_controller.dart';

class MemberPickerView extends BottomSheetView<MemberPickerViewController> {
  const MemberPickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.initMembers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return BottomSheetErrorView(title: controller.title.value);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return BottomSheetLoadingView(title: controller.title.value);
          }
          return BottomSheetLayout(
              title: controller.title.value,
              content: Column(
                  children: List.generate(
                      controller.clubMembers.length,
                      (idx) => Obx(() => MemberPickerRow(
                          clubMember: controller.clubMembers[idx],
                          isSelected:
                              controller.selectedMembers.contains(controller.clubMembers[idx]),
                          multipleSelect: controller.multipleSelect,
                          onSelected: controller.toggleSelect)))),
              buttons: [
                RoundedRectangleFullButton(title: "선택 완료", onTap: controller.selectMembers)
              ]);
        });
  }
}
