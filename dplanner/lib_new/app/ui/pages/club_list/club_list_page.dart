import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../../../../config/constants/app_colors.dart';
import '../../base/widgets/ad_banner.dart';
import '../../base/widgets/base_appbar.dart';
import '../../base/widgets/base_scrollable_listview.dart';
import '../../base/widgets/padded_safe_area.dart';
import 'club_list_controller.dart';
import 'widgets/club_card.dart';

class ClubListPage extends GetView<ClubListController> {
  const ClubListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgPrimary,
        appBar: BaseAppBar(
          title: const Text("클럽 목록"),
          actions: [
            IconButton(
              onPressed: controller.toAppSettingPage,
              icon: const Icon(SFSymbols.gear_alt_fill),
            )
          ],
        ),
        body: Column(
          children: [
            const AdBanner(),
            Expanded(
              child: PaddedSafeArea(
                  child: BaseScrollableListView(
                onRefresh: controller.getMyClubList,
                children: [
                  const SizedBox(height: 8),
                  Obx(() {
                    return Column(
                        children: List.generate(
                            controller.clubs.length,
                            (idx) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ClubCard(
                                      club: controller.clubs[idx], onTap: controller.enterToClub),
                                )));
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: InkWell(
                      splashColor: AppColors.subColor2.withOpacity(0.5),
                      highlightColor: AppColors.subColor2.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      onTap: controller.toClubJoinPage,
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.bgWhite,
                        ),
                        child: SizedBox(
                          height: 104,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Icon(
                                  SFSymbols.plus,
                                  size: 28,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("새로운 클럽에 가입해보세요!",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(color: AppColors.primaryColor)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("내가 찾는 클럽이 없다면? ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: AppColors.textGray)),
                      InkWell(
                        onTap: controller.toClubCreatePage,
                        borderRadius: BorderRadius.circular(5),
                        child: Text("클럽 만들기",
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: AppColors.textGray, decoration: TextDecoration.underline)),
                      ),
                    ],
                  )
                ],
              )),
            ),
          ],
        ));
  }
}
