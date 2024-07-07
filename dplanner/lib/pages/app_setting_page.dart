import 'package:dplanner/const/const.dart';
import 'package:dplanner/pages/error_page.dart';
import 'package:dplanner/pages/eula_consent_page.dart';
import 'package:dplanner/pages/simple_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../const/style.dart';
import '../widgets/snack_bar.dart';

class AppSettingPage extends StatefulWidget {
  const AppSettingPage({super.key});

  @override
  State<AppSettingPage> createState() => _AppSettingPageState();
}

class _AppSettingPageState extends State<AppSettingPage> {
  static const storage = FlutterSecureStorage();
  String userMail = "";
  String userLogin = "";

  Future<String> findLoginInfo() async {
    return await storage.read(key: loginInfo) ?? ". . none";
  }

  String findLoginPlatform(String login) {
    userLogin = login;
    print(login);
    switch (login) {
      case "kakao":
        return 'assets/images/login/icon_kakao.png';
      case "naver":
        return 'assets/images/login/icon_naver.png';
      case "google":
        return 'assets/images/login/icon_google.png';
      case "apple":
        return 'assets/images/login/icon_apple.png';
      default:
        return 'assets/images/login/icon_apple.png';
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
            infoRow(title: "가입 정보", value: ""),
            FutureBuilder<String>(
                future: findLoginInfo(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  userMail = snapshot.data?.split(" ")[0] ?? "";
                  if (snapshot.hasError) {
                    return const ErrorPage(constraints: BoxConstraints());
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 32),
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
                                  userMail,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),

                          ///TODO: 가입 날짜 받기
                          const Text(
                            "",
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
            infoRow(title: "앱 버전", value: appVersion),
            // buttonRow(title: "푸시 알림 설정", onTap: () {}),
            buttonRow(
                title: "개인정보 처리방침",
                onTap: () => Get.to(const SimpleInfoPage(
                    title: "개인정보 처리방침",
                    filePath: "assets/texts/privacy_info.txt"))),
            buttonRow(
                title: "서비스 이용약관(EULA)",
                onTap: () => Get.to(const SimpleInfoPage(
                    title: "서비스 이용약관",
                    filePath: "assets/texts/service_term_info.txt"))),
            buttonRow(
                title: "문의하기",
                onTap: () {
                  _sendEmail();
                }),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getUserInfo() {
    return {
      '로그인 정보': userLogin,
      '로그인 계정': userMail,
    };
  }

  Future<String> _getEmailBody() async {
    Map<String, dynamic> userInfo = _getUserInfo();
    // Map<String, dynamic> appInfo = await _getAppInfo();
    // Map<String, dynamic> deviceInfo = await _getDeviceInfo();

    String body = "";

    body += "==============\n";
    body += "아래 내용을 함께 보내주시면 큰 도움이 됩니다!\n";

    userInfo.forEach((key, value) {
      body += "$key: $value\n";
    });

    // appInfo.forEach((key, value) {
    //   body += "$key: $value\n";
    // });
    //
    // deviceInfo.forEach((key, value) {
    //   body += "$key: $value\n";
    // });

    body += "==============\n\n";
    body += "문의할 내용을 적어주세요.\n";

    return body;
  }

  void _sendEmail() async {
    String body = await _getEmailBody();

    final Email email = Email(
      body: body,
      subject: '[DPlanner 문의]',
      recipients: ['dplanner2233@gmail.com'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      String title =
          "기본 메일 앱을 사용할 수 없기 때문에 앱에서 바로 문의를 전송하기 어려운 상황입니다.\n\n아래 이메일로 연락주시면 친절하게 답변해드릴게요 :)\n\ndplanner2233@gmail.com";
      String message = "";
      snackBar(title: title, content: message);
    }
  }

  Widget buttonRow({
    required String title,
    required void Function()? onTap,
  }) {
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
          const Icon(
            SFSymbols.chevron_right,
            size: 20,
            color: AppColor.textColor,
          ),
        ],
      ),
    );
  }

  Widget infoRow({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
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
          Text(
            value,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColor.textColor2),
          ),
        ],
      ),
    );
  }
}
