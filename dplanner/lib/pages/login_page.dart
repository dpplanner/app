import 'dart:convert';
import 'dart:io';

import 'package:dplanner/decode_token.dart';
import 'package:dplanner/widgets/image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../const.dart';
import '../controllers/club.dart';
import '../controllers/member.dart';
import '../services/club_api_service.dart';
import '../services/club_member_api_service.dart';
import '../services/token_api_service.dart';
import '../style.dart';

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../widgets/snack_bar.dart';
import 'error_page.dart';

GoogleSignIn googleSignIn = GoogleSignIn();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  // refresh token 유효성 검사
  bool checkRefreshToken(String token) {
    final payloadMap = decodeToken(token);

    if (payloadMap['exp'] * 1000 > DateTime.now().millisecondsSinceEpoch) {
      return true;
    } else {
      return false;
    }
  }

  ///TODO: 와이파이 상태 확인 에러 알려주기
  // 로그인 상태 확인
  Future<void> checkUserLogin() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    ///TODO: fluttersecurestorage 일부 기종 문제 해결
    String? refreshToken;
    String? accessToken;
    try {
      refreshToken = await storage.read(key: refreshTokenKey);
      accessToken = await storage.read(key: accessTokenKey);
    } catch (e) {
      print(e.toString());
    }

    // refreshToken 으로 로그인 상태 확인
    if (refreshToken != null && checkRefreshToken(refreshToken)) {
      print("토큰");
      print(accessToken);
      print(refreshToken);
      print(decodeToken(accessToken!));
      print(decodeToken(refreshToken));
      try {
        ClubController.to.club.value = await ClubApiService.getClub(
            clubID: decodeToken(accessToken)['recent_club_id']);
        MemberController.to.clubMember.value =
            await ClubMemberApiService.getClubMember(
                clubId: decodeToken(accessToken)['recent_club_id'],
                clubMemberId: decodeToken(accessToken)['club_member_id']);
        if (MemberController.to.clubMember().isConfirmed) {
          Get.offNamed('/tab2', arguments: 1);
        } else {
          Get.offNamed('/club_list');
        }
      } catch (e) {
        print(e.toString());
      }
    }
    FlutterNativeSplash.remove();
  }

  Future<void> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // 서버에 사용자 정보를 전송하고 애플 로그인 처리
      String email = credential.email ?? ".";
      String name =
          "${credential.givenName ?? "."} ${credential.familyName ?? "."}";

      await TokenApiService.postToken(email: email, name: name);
      await storage.write(key: loginInfo, value: '$email $name apple');

      // 로그인 성공 후 화면 전환
      Get.offNamed('/club_list');
    } catch (e) {
      print(e.toString());
      snackBar(title: "애플 로그인 실패", content: e.toString());
    }
  }

  // 구글 로그인
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      try {
        String email = googleUser.email;
        String name = googleUser.displayName ?? ".";
        await TokenApiService.postToken(email: email, name: name);
        await storage.write(key: loginInfo, value: '$email $name google');

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

      String email = user.kakaoAccount!.email ?? ".";
      String name = user.kakaoAccount!.name ?? ".";
      await TokenApiService.postToken(email: email, name: name);
      await storage.write(key: loginInfo, value: '$email $name kakao');

      Get.offNamed('/club_list');
    } catch (e) {
      print(e.toString());
      snackBar(title: "카카오 로그인 실패", content: e.toString());
    }
  }

  // 네이버 로그인
  Future<void> signInWithNaver() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status == NaverLoginStatus.loggedIn) {
      try {
        String email = result.account.email;
        String name = result.account.name;
        await TokenApiService.postToken(email: email, name: name);
        await storage.write(key: loginInfo, value: '$email $name naver');

        Get.offNamed('/club_list');
      } catch (e) {
        print(e.toString());
        snackBar(title: "네이버 로그인 실패", content: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: FutureBuilder(
            future: checkUserLogin(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const ErrorPage();
              } else {
                return SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 128.0, bottom: 256.0),
                          child: SvgPicture.asset(
                            'assets/images/login/dplanner_logo_login.svg',
                          ),
                        ),

                        //카카오 로그인 버튼
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 5, 24, 5),
                          child: ImageButton(
                              image: 'assets/images/login/login_kakao.png',
                              onTap: () async {
                                await signInWithKakao();
                              }),
                        ),

                        //네이버 로그인 버튼
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 5, 24, 5),
                          child: ImageButton(
                              image: 'assets/images/login/login_naver.png',
                              onTap: () async {
                                await signInWithNaver();
                              }),
                        ),

                        //구글 로그인 버튼
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 5, 24, 5),
                          child: ImageButton(
                              image: 'assets/images/login/login_google.png',
                              onTap: () async {
                                await signInWithGoogle();
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 5, 24, 5),
                          child: SignInWithAppleButton(
                            onPressed: () async {
                              await signInWithApple();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}
