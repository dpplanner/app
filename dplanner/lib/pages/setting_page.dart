import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../const/const.dart';
import '../controllers/size.dart';
import '../services/member_service.dart';
import '../const/style.dart';
import '../widgets/nextpage_button.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(SFSymbols.chevron_left)),
          title: const Text(
            "설정",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            selectButton("앱 설정", () {
              Get.toNamed('/app_setting');
            }, true),
            selectButton("로그아웃", () {
              signOut();
            }, false),
            selectButton("탈퇴하기", () {
              checkLeaveApp();
            }, false),
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        backgroundColor: AppColor.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      onPressed: onTap,
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
    );
  }

  Future<void> checkLeaveApp() async {
    await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Center(
            child: Text(
              "계정 탈퇴",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "탈퇴 시 모든 계정 및",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Text(
              "가입 클럽 활동 정보가 삭제되며",
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
                      await MemberApiService.deleteMember();
                      Get.offAllNamed('/');
                    } catch (e) {
                      print(e.toString());
                      snackBar(title: "앱을 탈퇴하지 못했습니다.", content: "잠시 후 다시 시도해 주세요");
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
