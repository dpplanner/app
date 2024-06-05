import 'dart:async';

import 'package:dplanner/services/club_api_service.dart';
import 'package:dplanner/style.dart';
import 'package:dplanner/widgets/club_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../const.dart';
import '../controllers/club.dart';
import '../controllers/member.dart';
import '../controllers/size.dart';
import '../decode_token.dart';
import '../models/club_model.dart';
import '../services/club_member_api_service.dart';
import '../services/token_api_service.dart';
import '../widgets/snack_bar.dart';
import 'error_page.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dplanner/services/club_alert_api_service.dart';

import 'loading_page.dart';

class ClubListPage extends StatefulWidget {
  const ClubListPage({super.key});

  @override
  State<ClubListPage> createState() => _ClubListPageState();
}

class _ClubListPageState extends State<ClubListPage> {
  final StreamController<List<ClubModel>> streamController =
      StreamController<List<ClubModel>>();

  @override
  void initState() {
    super.initState();
    getClubList();
    sendFCMtoken();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  void sendFCMtoken() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final fcmToken = await firebaseMessaging.getToken();
    ClubAlertApiService.refreshFCMToken(fcmToken);
  }

  // 클럽 목록 불러오기
  Future<void> getClubList() async {
    try {
      streamController.add(await ClubApiService.getClubList());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.backgroundColor2,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: AppColor.backgroundColor,
            scrolledUnderElevation: 0,
            leadingWidth: SizeController.to.screenWidth * 0.25,
            leading: SvgPicture.asset(
              'assets/images/base_image/dplanner_logo_mini.svg',
              fit: BoxFit.none,
            ),
            title: const Text(
              "클럽 목록",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Get.toNamed('/setting');
                },
                icon: const Icon(
                  SFSymbols.gear_alt_fill,
                  color: AppColor.textColor,
                ),
              ),
              SizedBox(width: SizeController.to.screenWidth * 0.05)
            ],
            centerTitle: true,
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => RefreshIndicator(
                onRefresh: getClubList,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: StreamBuilder<List<ClubModel>>(
                      stream: streamController.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ClubModel>> snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.hasData == false) {
                          return LoadingPage(constraints: constraints);
                        } else if (snapshot.hasError) {
                          return ErrorPage(constraints: constraints);
                        } else {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                    children: List.generate(
                                        snapshot.data!.length, (index) {
                                  return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          18.0, 12.0, 18.0, 0.0),
                                      child: ClubCard(
                                        thisClub: snapshot.data![index],
                                        event: () async {
                                          if (snapshot
                                                  .data![index].isConfirmed ??
                                              false) {
                                            try {
                                              const storage =
                                                  FlutterSecureStorage();
                                              String? accessToken =
                                                  await storage.read(
                                                      key: accessTokenKey);
                                              await TokenApiService
                                                  .patchUpdateClub(
                                                      memberId: decodeToken(
                                                          accessToken!)['sub'],
                                                      clubId: snapshot
                                                          .data![index].id
                                                          .toString());
                                              String? updatedAccessToken =
                                                  await storage.read(
                                                      key: accessTokenKey);
                                              ClubController.to.club.value =
                                                  await ClubApiService.getClub(
                                                      clubID: decodeToken(
                                                              updatedAccessToken!)[
                                                          'recent_club_id']);
                                              MemberController
                                                      .to.clubMember.value =
                                                  await ClubMemberApiService.getClubMember(
                                                      clubId: decodeToken(
                                                              updatedAccessToken)[
                                                          'recent_club_id'],
                                                      clubMemberId: decodeToken(
                                                              updatedAccessToken)[
                                                          'club_member_id']);
                                              Get.toNamed('/tab2',
                                                  arguments: 1);
                                            } catch (e) {
                                              print(e.toString());
                                            }
                                          } else {
                                            getClubList();
                                            snackBar(
                                                title: "해당 클럽에 가입 진행 중입니다.",
                                                content: "가입 후에 눌러주세요.");
                                          }
                                        },
                                      ));
                                })),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    18.0, 12.0, 18.0, 12.0),
                                child: InkWell(
                                  ///TODO: 스플래시 컬러 지정
                                  splashColor:
                                      AppColor.subColor2.withOpacity(0.5),
                                  highlightColor:
                                      AppColor.subColor2.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    Get.toNamed('/club_join1');
                                  },
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: AppColor
                                          .backgroundColor, // 원하는 색상으로 변경
                                    ),
                                    child: SizedBox(
                                      width: SizeController.to.screenWidth,
                                      height:
                                          SizeController.to.screenHeight * 0.13,
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            SFSymbols.plus,
                                            size: 35,
                                            color: AppColor.objectColor,
                                          ),
                                          SizedBox(width: 8),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 5),
                                              Text(
                                                "새로운 클럽에 가입해보세요!",
                                                style: TextStyle(
                                                  color: AppColor.objectColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 24.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "내가 찾는 클럽이 없다면? ",
                                      style: TextStyle(
                                          color: AppColor.textColor2,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed('/club_create1');
                                      },
                                      borderRadius: BorderRadius.circular(5),
                                      child: const Text(
                                        "클럽 만들기",
                                        style: TextStyle(
                                            color: AppColor.textColor2,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                AppColor.textColor2,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                )),
          ),
        ));
  }
}
