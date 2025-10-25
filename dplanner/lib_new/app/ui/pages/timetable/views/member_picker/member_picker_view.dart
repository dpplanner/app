import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../base/widgets/base_bottom_sheet_view.dart';
import '../../../../base/widgets/buttons/rounded_rectangle_full_button.dart';
import '../../widgets/row/member_picker_row.dart';
import '../bottom_sheet_view.dart';
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
          return BaseBottomSheetView(
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
