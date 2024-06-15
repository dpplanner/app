import 'dart:async';

import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/controllers/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../models/resource_model.dart';
import '../services/club_api_service.dart';
import '../services/resource_api_service.dart';
import '../const/style.dart';
import '../widgets/nextpage_button.dart';
import '../widgets/snack_bar.dart';
import 'error_page.dart';

class ClubInfoPage extends StatefulWidget {
  const ClubInfoPage({super.key});

  @override
  State<ClubInfoPage> createState() => _ClubInfoPageState();
}

class _ClubInfoPageState extends State<ClubInfoPage> {
  Future<int> getResourceNum() async {
    try {
      List<List<ResourceModel>> resources =
          await ResourceApiService.getResources();
      ClubController.to.resources.value = resources[0] + resources[1];
      return resources[0].length + resources[1].length;
    } catch (e) {
      print(e.toString());
    }
    return 0;
  }

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
            "클럽 정보",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
              child: Visibility(
                visible: (ClubController.to.club().url == null),
                replacement: Image.network(
                  "https://${ClubController.to.club().url}",
                  height: SizeController.to.screenHeight * 0.28,
                  width: SizeController.to.screenWidth,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Container(
                      color: AppColor.backgroundColor,
                      height: SizeController.to.screenHeight * 0.28,
                      width: SizeController.to.screenWidth,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Image',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Failed',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                child: SvgPicture.asset(
                  'assets/images/base_image/base_club_big_image.svg',
                  height: SizeController.to.screenHeight * 0.28,
                  width: SizeController.to.screenWidth,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Text(
              ClubController.to.club().clubName,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: Text(
                ClubController.to.club().info,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 24.0),
                      child: Text(
                        "전체 회원",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                    ),
                    Row(
                      children: [
                        Obx(() {
                          return Text(
                            "${ClubController.to.club().memberCount}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          );
                        }),
                        InkWell(
                          onTap: () {
                            Get.toNamed('/club_member_list');
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              SFSymbols.chevron_down,
                              color: AppColor.textColor,
                              size: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.0),
                      child: Text(
                        "게시글",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                    ),
                    Text(
                      "12",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 24.0),
                      child: Text(
                        "공유 물품",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                    ),
                    Row(
                      children: [
                        FutureBuilder(
                            future: getResourceNum(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData == false) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return const ErrorPage();
                              } else {
                                return Obx(() {
                                  return Text(
                                    "${ClubController.to.resources().length}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  );
                                });
                              }
                            }),
                        InkWell(
                          onTap: () {
                            Get.toNamed('/resource_list');
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              SFSymbols.chevron_down,
                              color: AppColor.textColor,
                              size: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
            Expanded(child: Container()),
            (MemberController.to.clubMember().role == "ADMIN")
                ? Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 40.0),
                    child: Center(
                      child: NextPageButton(
                        text: const Text(
                          "초대코드 복사하기",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColor.backgroundColor),
                        ),
                        buttonColor: AppColor.objectColor,
                        onPressed: () async {
                          try {
                            Clipboard.setData(ClipboardData(
                                text: await ClubApiService.postClubCode(
                                    clubId: ClubController.to.club().id)));
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 40.0),
                    child: Center(
                      child: NextPageButton(
                        text: const Text(
                          "이 클럽 탈퇴하기",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColor.backgroundColor),
                        ),
                        buttonColor: AppColor.markColor,
                        onPressed: () async {
                          try {
                            checkLeaveClub();
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Future<void> checkLeaveClub() async {
    await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Center(
            child: Text(
              "${ClubController.to.club().clubName} 클럽 탈퇴",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "탈퇴 시 클럽 내 모든 활동 정보가 삭제되며",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Text(
              "삭제된 정보는 복구할 수 없습니다.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                "정말 탈퇴하시겠습니까?",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        actions: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: NextPageButton(
                  text: const Text(
                    "탈퇴하기",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.backgroundColor),
                  ),
                  buttonColor: AppColor.objectColor,
                  onPressed: () async {
                    try {
                      await ClubApiService.leaveClub(
                          clubId: ClubController.to.club().id,
                          clubMemberId: MemberController.to.clubMember().id);
                      Get.offAllNamed('club_list');
                    } catch (e) {
                      print(e.toString());
                      snackBar(title: "클럽 탈퇴 실패", content: e.toString());
                    }
                  },
                ),
              ),
              TextButton(
                onPressed: Get.back,
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.transparent;
                      }
                      return Colors.transparent;
                    },
                  ),
                ),
                child: const Text(
                  "취소",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textColor2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
