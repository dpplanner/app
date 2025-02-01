import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../../../../config/constants/app_colors.dart';
import '../../base/widgets/base_appbar.dart';
import '../../base/widgets/buttons/rounded_rectangle_full_button.dart';
import '../../base/widgets/padded_safe_area.dart';
import 'club_create_success_controller.dart';

// TODO UI 재설계
class ClubCreateSuccessPage extends GetView<ClubCreateSuccessController> {
  const ClubCreateSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      appBar: BaseAppBar(title: const Text("클럽 만들기")),
      body: PaddedSafeArea(
        child: Column(
          children: [
            const SizedBox(height: 64),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("클럽", style: Theme.of(context).textTheme.displayMedium),
                    Text(
                      " ${controller.club.clubName} ",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: AppColors.primaryColor),
                    ),
                    Text(
                      "를 만들었어요!",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "더 다양하게 클럽을 꾸미고 싶다면 설정에서 바꿀 수 있어요",
                  style:
                      Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.textGray),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "이제 회원을 모집해볼까요?",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "초대 링크를 받은 사람은",
                    style:
                        Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.textGray),
                  ),
                  Text(
                    "클럽 가입 신청을 보낼 수 있어요",
                    style:
                        Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.textGray),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: IconButton(
                          padding: const EdgeInsets.all(24.0),
                          icon: const Icon(SFSymbols.link, color: AppColors.textBlack),
                          style: IconButton.styleFrom(
                              backgroundColor: AppColors.subColor4,
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                          onPressed: controller.copyInviteCode,
                        )),
                    Text("초대링크 복사하기", style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            RoundedRectangleFullButton(
              title: "클럽 시작하기",
              onTap: controller.toPostListPage
            )
          ],
        ),
      ),
    );
  }
}
