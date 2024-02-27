import 'dart:convert';
import 'dart:io';

import 'package:dplanner/widgets/image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../const.dart';
import '../controllers/login.dart';
import '../services/user_api_service.dart';
import '../style.dart';

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_naver_login/flutter_naver_login.dart';

GoogleSignIn googleSignIn = GoogleSignIn();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const storage = FlutterSecureStorage();
  final loginController = Get.put((LoginController()));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserLogin();
    });
  }

  // JWT 토큰 디코드
  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  // refresh token 유효성 검사
  bool checkRefreshToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    if (payloadMap['exp'] * 1000 > DateTime.now().millisecondsSinceEpoch) {
      return true;
    } else {
      return false;
    }
  }

  // 로그인 상태 확인
  void checkUserLogin() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    String? refreshToken = await storage.read(key: refreshTokenKey);

    // refreshToken 으로 로그인 상태 확인
    if (refreshToken != null && checkRefreshToken(refreshToken)) {
      Get.offNamed('/club_list');
    }
    FlutterNativeSplash.remove();
  }

  // 구글 로그인
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      try {
        await UserApiService.postUserLogin(
            email: googleUser!.email, name: googleUser.displayName ?? "이름없음");
      } catch (e) {
        print(e.toString());
        errorSnackBar(title: "구글 로그인 실패", content: e.toString());
      }

      setState(() {
        loginController.loginPlatform.value = LoginPlatform.google;
      });
    }
  }

  // 카카오 로그인
  Future<void> signInWithKakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);
      print(profileInfo.toString());

      User user = await UserApi.instance.me();

      await UserApiService.postUserLogin(
          email: user.kakaoAccount!.email ?? "이메일 없음",
          name: user.kakaoAccount!.name ?? "이름없음");

      setState(() {
        loginController.loginPlatform.value = LoginPlatform.kakao;
      });
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
      errorSnackBar(title: "카카오톡 로그인 실패", content: error.toString());
    }
  }

  // 네이버 로그인
  Future<void> signInWithNaver() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status == NaverLoginStatus.loggedIn) {
      try {
        await UserApiService.postUserLogin(
            email: result.account.email, name: result.account.name);
      } catch (e) {
        print(e.toString());
        errorSnackBar(title: "구글 로그인 실패", content: e.toString());
      }

      setState(() {
        loginController.loginPlatform.value = LoginPlatform.naver;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 128.0, bottom: 256.0),
                child: SvgPicture.asset(
                  'assets/images/login/dplanner_logo_login.svg',
                ),
              ),

              ///TODO: 이미지 변경 필요
              //카카오 로그인 버튼
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ImageButton(
                    image: 'assets/images/login/kakao_login.svg',
                    onTap: () async {
                      if (loginController.loginPlatform.value ==
                          LoginPlatform.none) {
                        await signInWithKakao();
                        Get.offNamed('/club_list');
                      } else {
                        errorSnackBar(
                            title:
                                "${loginController.loginPlatform.value.title}로그인 중입니다.",
                            content: "로그아웃을 먼저 진행해주세요");
                      }
                    }),
              ),

              //네이버 로그인 버튼
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ImageButton(
                    image: 'assets/images/login/naver_login.svg',
                    onTap: () async {
                      if (loginController.loginPlatform.value ==
                          LoginPlatform.none) {
                        await signInWithNaver();
                        Get.offNamed('/club_list');
                      } else {
                        errorSnackBar(
                            title:
                                "${loginController.loginPlatform.value.title}로그인 중입니다.",
                            content: "로그아웃을 먼저 진행해주세요");
                      }
                    }),
              ),

              //구글 로그인 버튼
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ImageButton(
                    image: 'assets/images/login/facebook_login.svg',
                    onTap: () async {
                      if (loginController.loginPlatform.value ==
                          LoginPlatform.none) {
                        await signInWithGoogle();
                        Get.offNamed('/club_list');
                      } else {
                        errorSnackBar(
                            title:
                                "${loginController.loginPlatform.value.title}로그인 중입니다.",
                            content: "로그아웃을 먼저 진행해주세요");
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 에러 메세지 출력 스낵바
  void errorSnackBar({required String title, required String content}) {
    Get.snackbar(title, content,
        colorText: AppColor.textColor,
        backgroundColor: AppColor.backgroundColor,
        snackPosition: SnackPosition.BOTTOM);
  }
}
