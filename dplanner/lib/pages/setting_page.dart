import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../const.dart';
import '../controllers/member.dart';
import '../controllers/size.dart';
import '../style.dart';

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
              snackBar(title: "개발 진행 중입니다", content: "추후에 이용해주세요");
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
