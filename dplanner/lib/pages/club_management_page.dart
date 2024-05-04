import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/member.dart';
import '../controllers/size.dart';
import '../style.dart';

class ClubManagementPage extends StatefulWidget {
  const ClubManagementPage({super.key});

  @override
  State<ClubManagementPage> createState() => _ClubManagementPageState();
}

class _ClubManagementPageState extends State<ClubManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColor.backgroundColor,
          scrolledUnderElevation: 0,
          leadingWidth: SizeController.to.screenWidth * 0.2,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(SFSymbols.chevron_left)),
          title: const Text(
            "클럽 관리",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            selectButton("클럽 설정", () {
              if (MemberController.to.clubMember().role == "ADMIN") {
                Get.toNamed('/club_setting');
              } else {
                snackBar(title: "권한이 없습니다", content: "클럽 관리자만 클럽 설정이 가능합니다");
              }
            }, true),
            selectButton("회원 목록", () {
              Get.toNamed('/club_member_list');
            }, true),
            selectButton("예약 요청", () {
              if (MemberController.to.clubMember().role == "ADMIN" ||
                  (MemberController.to.clubMember().clubAuthorityTypes !=
                          null &&
                      MemberController.to
                          .clubMember()
                          .clubAuthorityTypes!
                          .contains("SCHEDULE_ALL"))) {
                Get.toNamed('/reservation_list');
              } else {
                snackBar(title: "권한이 없습니다", content: "클럽 관리자에게 권한을 요청하세요");
              }
            }, true),
            selectButton("공유 물품 목록", () {
              Get.toNamed('/resource_list');
            }, true),
            selectButton("클럽 매니저 관리", () {
              if (MemberController.to.clubMember().role == "ADMIN") {
                Get.toNamed('/club_manager_list');
              } else {
                snackBar(
                    title: "권한이 없습니다", content: "클럽 관리자만 클럽 매니저 관리가 가능합니다");
              }
            }, true),
            selectButton("게시판 신고 관리", () {
              snackBar(title: "개발 진행 중입니다", content: "추후에 이용해주세요");
            }, true),
          ],
        ),
      ),
    );
  }

  Widget selectButton(
    String title,
    void Function()? onTap,
    bool isIcon,
  ) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: AppColor.textColor,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        backgroundColor: AppColor.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textColor),
            ),
            if (isIcon)
              const Icon(
                SFSymbols.chevron_right,
                size: 20,
                color: AppColor.textColor,
              ),
          ],
        ),
      ),
    );
  }
}
