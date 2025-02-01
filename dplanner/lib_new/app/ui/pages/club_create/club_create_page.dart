import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/constants/app_colors.dart';
import '../../base/widgets/base_appbar.dart';
import '../../base/widgets/buttons/rounded_rectangle_full_button.dart';
import '../../base/widgets/outline_textform.dart';
import '../../base/widgets/padded_safe_area.dart';
import '../../base/widgets/underline_textform.dart';
import 'club_create_controller.dart';
import 'club_create_validator.dart';

class ClubCreatePage extends GetView<ClubCreateController> {
  const ClubCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      resizeToAvoidBottomInset: false,
      appBar: BaseAppBar(
        leadingType: LeadingType.BACK,
        title: const Text("클럽 만들기"),
      ),
      body: PaddedSafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Text("만들고 싶은 ", style: Theme.of(context).textTheme.headlineMedium),
                          Text("클럽의 이름", style: Theme.of(context).textTheme.displaySmall),
                          Text("을 적어주세요", style: Theme.of(context).textTheme.headlineMedium),
                        ],
                      ),
                    ),
                    Form(
                        key: controller.clubNameFormKey,
                        child: Obx(() => UnderlineTextForm(
                              hintText: '클럽 이름은 수정할 수 없으니 신중히 적어주세요',
                              maxLength: ClubCreateValidator.MAX_CLUB_NAME_LENGTH,
                              controller: controller.clubNameForm,
                              isFocused: controller.clubNameFormFocused.value,
                              validator: controller.validator.validateClubName,
                              onChanged: (value) =>
                                  controller.clubNameFormFocused.value = value.isNotEmpty,
                            ))),
                    const SizedBox(height: 64.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Text("우리 클럽을 소개하는 ", style: Theme.of(context).textTheme.headlineMedium),
                          Text("소개글", style: Theme.of(context).textTheme.displaySmall),
                          Text("도 적어주세요", style: Theme.of(context).textTheme.headlineMedium),
                        ],
                      ),
                    ),
                    Form(
                        key: controller.clubInfoFormKey,
                        child: Obx(() => OutlineTextForm(
                              hintText:
                                  '${ClubCreateValidator.MAX_CLUB_INFO_LENGTH} 자 내로 작성할 수 있어요\n관리자는 클럽 소개글을 언제든지 수정할 수 있으니 편하게 작성해주세요',
                              controller: controller.clubInfoForm,
                              isFocused: controller.clubInfoFormFocused.value,
                              maxLines: 5,
                              validator: controller.validator.validateClubInfo,
                              onChanged: (value) =>
                                  controller.clubInfoFormFocused.value = value.isNotEmpty,
                            ))),
                  ],
                ),
              ),
            ),
            Obx(() => RoundedRectangleFullButton(
                  title: "클럽 만들기",
                  onTap: controller.createClub,
                  color: controller.isComplete.value ? AppColors.primaryColor : AppColors.subColor3,
                )),
          ],
        ),
      ),
    );
  }
}
