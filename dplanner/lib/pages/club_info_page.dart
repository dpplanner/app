import 'dart:async';

import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/models/club_member_model.dart';
import 'package:dplanner/pages/club_member_list_page.dart';
import 'package:dplanner/pages/club_resource_list_page.dart';
import 'package:dplanner/services/club_member_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../models/resource_model.dart';
import '../services/club_api_service.dart';
import '../services/resource_api_service.dart';
import '../style.dart';
import '../widgets/nextpage_button.dart';
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
                child: Image.asset(
                  'assets/images/dancepozz_big_logo.png',
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
                            Get.to(const ClubMemberListPage());
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
                        Obx(() {
                          return Text(
                            "${ClubController.to.resources().length}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          );
                        }),
                        InkWell(
                          onTap: () {
                            Get.to(const ClubResourceListPage());
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
                            print(await ClubApiService.postClubCode(
                                clubId: ClubController.to.club().id));
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
                            print(MemberController.to.clubMember().id);
                            await ClubApiService.deleteClub(
                                clubId: ClubController.to.club().id,
                                clubMemberId:
                                    MemberController.to.clubMember().id);
                            Get.offAllNamed('club_list');
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
}
