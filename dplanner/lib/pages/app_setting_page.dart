import 'package:dplanner/const.dart';
import 'package:dplanner/pages/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';

class AppSettingPage extends StatefulWidget {
  const AppSettingPage({super.key});

  @override
  State<AppSettingPage> createState() => _AppSettingPageState();
}

class _AppSettingPageState extends State<AppSettingPage> {
  static const storage = FlutterSecureStorage();

  Future<String> findLoginInfo() async {
    return await storage.read(key: loginInfo) ?? ". . none";
  }

  String findLoginPlatform(String login) {
    switch (login) {
      case "kakao":
        return 'assets/images/login/icon_kakao.png';
      case "naver":
        return 'assets/images/login/icon_naver.png';
      case "google":
        return 'assets/images/login/icon_google.png';
      default:
        return 'assets/images/login/icon_kakao.png';
    }
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
            "앱 설정",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            selectButton("가입 정보", () {}, false),
            FutureBuilder<String>(
                future: findLoginInfo(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasError) {
                    return const ErrorPage(constraints: BoxConstraints());
                  } else {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                height: 30,
                                width: 30,
                                findLoginPlatform(
                                    snapshot.data?.split(" ")[2] ?? ""),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  snapshot.data?.split(" ")[0] ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),

                          ///TODO: 가입 날짜 받기
                          const Text(
                            "23.09.10",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: AppColor.textColor2),
                          ),
                        ],
                      ),
                    );
                  }
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                selectButton("앱 버전 정보", () async {
                  String? a = await storage.read(key: loginInfo);
                  print(a);
                }, false),
                const Padding(
                  padding: EdgeInsets.only(right: 32.0),
                  child: Text(
                    "v1.0.2",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: AppColor.textColor2),
                  ),
                ),
              ],
            ),
            selectButton("푸시 알림 설정", () {}, false),
            selectButton("뭔가 설정", () {}, false),
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
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        backgroundColor: AppColor.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
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
