import 'dart:convert';
import 'dart:io';

import 'package:dplanner/decode_token.dart';
import 'package:dplanner/models/user_model.dart';
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

import '../widgets/snack_bar.dart';

GoogleSignIn googleSignIn = GoogleSignIn();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    checkUserLogin();
  }

  // refresh token 유효성 검사
  bool checkRefreshToken(String token) {
    final payloadMap = decodeToken(token);

    if (payloadMap['exp'] * 1000 > DateTime.now().millisecondsSinceEpoch) {
      return true;
    } else {
      return false;
    }
  }

  // 로그인 상태 확인
  Future<void> checkUserLogin() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    String? refreshToken = await storage.read(key: refreshTokenKey);
    String? accessToken = await storage.read(key: accessTokenKey);

    // refreshToken 으로 로그인 상태 확인
    if (refreshToken != null && checkRefreshToken(refreshToken)) {
      print("토큰");
      print(accessToken);
      print(refreshToken);
      print(decodeToken(accessToken!));
      print(decodeToken(refreshToken));
      Get.offNamed('/club_home');
    }
    FlutterNativeSplash.remove();
  }

  // 구글 로그인
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      try {
        await UserApiService.postUserLogin(
            email: googleUser.email, name: googleUser.displayName ?? "이름없음");

        setState(() {
          LoginController.to.user.value = UserModel(
              email: googleUser.email, name: googleUser.displayName ?? "이름없음");
          LoginController.to.loginPlatform.value = LoginPlatform.google;
        });

        Get.offNamed('/club_list');
      } catch (e) {
        print(e.toString());
        snackBar(title: "구글 로그인 실패", content: e.toString());
      }
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
        LoginController.to.user.value = UserModel(
            email: user.kakaoAccount!.email ?? "이메일 없음",
            name: user.kakaoAccount!.name ?? "이름없음");
        LoginController.to.loginPlatform.value = LoginPlatform.kakao;
      });

      Get.offNamed('/club_list');
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
      snackBar(title: "카카오톡 로그인 실패", content: error.toString());
    }
  }

  // 네이버 로그인
  Future<void> signInWithNaver() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status == NaverLoginStatus.loggedIn) {
      try {
        await UserApiService.postUserLogin(
            email: result.account.email, name: result.account.name);

        setState(() {
          LoginController.to.user.value =
              UserModel(email: result.account.email, name: result.account.name);
          LoginController.to.loginPlatform.value = LoginPlatform.naver;
        });

        Get.offNamed('/club_list');
      } catch (e) {
        print(e.toString());
        snackBar(title: "구글 로그인 실패", content: e.toString());
      }
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
                      if (LoginController.to.loginPlatform.value ==
                          LoginPlatform.none) {
                        await signInWithKakao();
                      } else {
                        snackBar(
                            title:
                                "${LoginController.to.loginPlatform.value.title}로그인 중입니다.",
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
                      if (LoginController.to.loginPlatform.value ==
                          LoginPlatform.none) {
                        await signInWithNaver();
                      } else {
                        snackBar(
                            title:
                                "${LoginController.to.loginPlatform.value.title}로그인 중입니다.",
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
                      if (LoginController.to.loginPlatform.value ==
                          LoginPlatform.none) {
                        await signInWithGoogle();
                      } else {
                        snackBar(
                            title:
                                "${LoginController.to.loginPlatform.value.title}로그인 중입니다.",
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
}
