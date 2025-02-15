import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/constants/app_colors.dart';
import '../../base/widgets/base_appbar.dart';
import '../../base/widgets/buttons/rounded_rectangle_full_button.dart';
import '../../base/widgets/outline_textform.dart';
import '../../base/widgets/padded_safe_area.dart';
import '../../base/widgets/underline_textform.dart';
import 'club_join_controller.dart';
import 'club_join_validator.dart';

class ClubJoinPage extends GetView<ClubJoinController> {
  const ClubJoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      resizeToAvoidBottomInset: false,
      appBar: BaseAppBar(
        leadingType: LeadingType.BACK,
        title: const Text("클럽 가입하기"),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("클럽 ", style: Theme.of(context).textTheme.headlineMedium),
                              Text(controller.club.clubName,
                                  style: Theme.of(context).textTheme.displaySmall),
                              Text(" 에서", style: Theme.of(context).textTheme.headlineMedium),
                            ],
                          ),
                          Text(
                            "사용하실 이름을 10글자 이내로 적어주세요",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                    Form(
                        key: controller.clubMemberNameFormKey,
                        child: Obx(() => UnderlineTextForm(
                              hintText: '이름을 적어주세요',
                              maxLength: ClubJoinValidator.MAX_CLUB_MEMBER_NAME_LENGTH,
                              controller: controller.clubMemberNameForm,
                              isFocused: controller.clubMemberNameFormFocused.value,
                              validator: controller.validator.validateClubMemberName,
                              onChanged: (value) =>
                                  controller.clubMemberNameFormFocused.value = value.isNotEmpty,
                            ))),
                    const SizedBox(height: 64.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("자신을 소개하는 글도 적어주세요(선택)",
                          style: Theme.of(context).textTheme.headlineMedium),
                    ),
                    Form(
                        key: controller.clubMemberInfoFormKey,
                        child: Obx(() => OutlineTextForm(
                              hintText:
                                  '${ClubJoinValidator.MAX_CLUB_MEMBER_INFO_LENGTH} 자 내로 작성할 수 있어요\n언제든지 수정할 수 있으니 편하게 작성해주세요',
                              controller: controller.clubMemberInfoForm,
                              isFocused: controller.clubMemberInfoFormFocused.value,
                              maxLines: 5,
                              validator: controller.validator.validateClubMemberInfo,
                              onChanged: (value) =>
                                  controller.clubMemberInfoFormFocused.value = value.isNotEmpty,
                            ))),
                  ],
                ),
              ),
            ),
            Obx(() => RoundedRectangleFullButton(
                  title: "가입 신청하기",
                  onTap: controller.joinClub,
                  color: controller.isComplete.value ? AppColors.primaryColor : AppColors.subColor3,
                )),
          ],
        ),
      ),
    );
  }
}
