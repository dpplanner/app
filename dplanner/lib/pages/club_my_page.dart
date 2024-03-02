import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/pages/app_setting_page.dart';
import 'package:dplanner/pages/club_info_page.dart';
import 'package:dplanner/pages/my_activity_check_page.dart';
import 'package:dplanner/pages/my_profile_modification_page.dart';
import 'package:dplanner/pages/reservation_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../const.dart';
import '../controllers/size.dart';
import '../style.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/reservation_mini_card.dart';
import 'club_management_page.dart';

class ClubMyPage extends StatefulWidget {
  const ClubMyPage({super.key});

  @override
  State<ClubMyPage> createState() => _ClubMyPageState();
}

class _ClubMyPageState extends State<ClubMyPage> {
  static const storage = FlutterSecureStorage();

  // 소셜 로그아웃
  void signOut() async {
    String loginPlatform = await storage.read(key: loginInfo) ?? ". . none";
    switch (loginPlatform.split(" ")[2]) {
      case "google":
        await GoogleSignIn().signOut();
        break;
      case "kakao":
        await UserApi.instance.logout();
        break;
      case "naver":
        await FlutterNaverLogin.logOut();
        break;
      case "none":
        break;
    }
    await storage.deleteAll();
    Get.offAllNamed('/');
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
            title: const Text(
              "마이페이지",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColor.backgroundColor2,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ///TODO: 이미지 바꾸기
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/jin_profile.png',
                                  height: SizeController.to.screenWidth * 0.25,
                                  width: SizeController.to.screenWidth * 0.25,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  MemberController.to.clubMember().name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                                Text(
                                  MemberController.to.clubMember().info ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(const MyProfileModificationPage());
                          },
                          borderRadius: BorderRadius.circular(5),
                          child: const Row(
                            children: [
                              Icon(
                                SFSymbols.pencil,
                                color: AppColor.textColor2,
                              ),
                              Text(
                                "프로필 편집하기",
                                style: TextStyle(
                                    color: AppColor.textColor2,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                selectButton("내 예약 목록", () {
                  Get.to(const ReservationListPage());
                }, true),
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: ReservationMiniCard(
                            title: "11/16 동방",
                            isAccepted: true,
                            name: "DP23 강지인",
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: ReservationMiniCard(
                            title: "11/18 동방",
                            isAccepted: false,
                            name: "DP22 정찬영",
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: ReservationMiniCard(
                            title: "11/22 동방",
                            isAccepted: true,
                            name: "DP22 임동현",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                selectButton("내 활동 보기", () {
                  Get.to(const MyActivityCheckPage());
                }, true),
                selectButton("클럽 정보", () {
                  Get.to(const ClubInfoPage(), arguments: 2);
                }, false),
                if (MemberController.to.clubMember().role == "ADMIN")
                  selectButton("클럽 관리", () {
                    Get.to(const ClubManagementPage());
                  }, false),
                Container(
                  height: SizeController.to.screenHeight * 0.01,
                  color: AppColor.backgroundColor2,
                ),
                selectButton("앱 설정", () {
                  Get.to(const AppSettingPage());
                }, false),
                selectButton("로그아웃", () {
                  signOut();
                }, false),
                selectButton("탈퇴하기", () {}, false),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomBar());
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
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
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
