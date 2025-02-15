import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/constants/app_colors.dart';
import '../../base/widgets/base_appbar.dart';
import '../../base/widgets/buttons/rounded_rectangle_full_button.dart';
import '../../base/widgets/padded_safe_area.dart';
import 'club_join_success_controller.dart';

// TODO UI 재설계
class ClubJoinSuccessPage extends GetView<ClubJoinSuccessController> {
  const ClubJoinSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      resizeToAvoidBottomInset: false,
      appBar: BaseAppBar(
        title: const Text("클럽 가입하기"),
      ),
      body: PaddedSafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 64),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("클럽 ", style: Theme.of(context).textTheme.headlineMedium),
            Text(controller.club.clubName, style: Theme.of(context).textTheme.displaySmall),
            Text(" 의", style: Theme.of(context).textTheme.headlineMedium),
          ]),
          Text("가입 신청이 완료되었어요!", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Text("클럽 관리자의 승인을 기다리고 있어요", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          Text("push 알림 권한을 승인해주시면",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.textGray)),
          Text("가입 완료 알림을 바로 보내드릴 수 있어요",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.textGray)),
          const Expanded(child: SizedBox()),
          RoundedRectangleFullButton(
            title: "클럽 목록으로 돌아가기",
            onTap: controller.toClubListPage,
          )
        ]),
      ),
    );
  }
}
