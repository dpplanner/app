import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../config/constants/app_colors.dart';
import '../../base/widgets/base_appbar.dart';
import '../../base/widgets/buttons/rounded_rectangle_full_button.dart';
import '../../base/widgets/padded_safe_area.dart';
import '../../base/widgets/underline_textform.dart';
import 'club_find_controller.dart';
import 'widgets/highlighted_club_card.dart';

class ClubFindPage extends GetView<ClubFindController> {
  const ClubFindPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.bgWhite,
      appBar: BaseAppBar(
        leadingType: LeadingType.BACK,
        title: const Text("클럽 찾기"),
      ),
      body: PaddedSafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("가입할 클럽을 찾기 위해", style: Theme.of(context).textTheme.headlineMedium),
                        Row(
                          children: [
                            Text("클럽 초대코드", style: Theme.of(context).textTheme.titleLarge),
                            Text("를 입력해 주세요", style: Theme.of(context).textTheme.headlineMedium),
                          ],
                        ),
                      ],
                    ),
                    Form(
                        key: controller.clubInviteCodeFormKey,
                        child: Obx(() => UnderlineTextForm(
                              hintText: '초대코드 입력하기',
                              controller: controller.clubInviteCodeForm,
                              isFocused: controller.clubInviteCodeFormFocused.value,
                              isDisabled: controller.clubInviteCodeSubmitted.value,
                              validator: controller.validator.validateClubInviteCode,
                              onChanged: (value) =>
                                  controller.clubInviteCodeFormFocused.value = value.isNotEmpty,
                            ))),
                    Obx(() {
                      if (controller.clubInviteCodeSubmitted.value) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 64.0, bottom: 16),
                              child: Text(
                                controller.club.value != null ? "찾으시는 클럽이 맞나요?" : "찾으시는 클럽이 없습니다",
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            if (controller.club.value != null)
                              HighlightedClubCard(club: controller.club.value!)
                          ],
                        );
                      } else {
                        return Container();
                      }
                    })
                  ],
                ),
              ),
            ),
            Obx(
              () => Visibility(
                  visible: controller.clubInviteCodeSubmitted.value,
                  replacement: RoundedRectangleFullButton(
                    title: "입력 완료",
                    color:
                        controller.isComplete.value ? AppColors.primaryColor : AppColors.subColor3,
                    onTap: controller.findClubByInviteCode,
                  ),
                  child: Column(
                    children: [
                      Visibility(
                          visible: controller.club.value != null,
                          child: RoundedRectangleFullButton(
                            title: "네, 맞아요",
                            onTap: controller.joinClub,
                            isLast: false,
                          )),
                      RoundedRectangleFullButton(
                        title: controller.club.value != null ? "아니오, 코드를 다시 입력할게요" : "코드를 다시 입력할게요",
                        color: AppColors.subColor3,
                        onTap: controller.clearForm,
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
