import 'dart:convert';
import 'dart:io';

import 'package:dplanner/controllers/size.dart';
import 'package:dplanner/decode_token.dart';
import 'package:dplanner/widgets/image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../const/const.dart';
import '../controllers/club.dart';
import '../controllers/member.dart';
import '../services/club_api_service.dart';
import '../services/club_member_api_service.dart';
import '../services/token_api_service.dart';
import '../const/style.dart';

import 'package:google_sign_in/google_sign_in.dart';
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
  String? eulaValue;

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
      eulaValue = await storage.read(key: eula);
    } catch (e) {
      print(e.toString());
    }

    // refreshToken 으로 로그인 상태 확인
    if (refreshToken != null && checkRefreshToken(refreshToken)) {
      print("토큰");
      print(accessToken);
      print(refreshToken);
      print(eulaValue);
      print(decodeToken(accessToken!));
      print(decodeToken(refreshToken));
      try {
        ClubController.to.club.value = await ClubApiService.getClub(
            clubID: decodeToken(accessToken)['recent_club_id']);
        MemberController.to.clubMember.value =
            await ClubMemberApiService.getClubMember(
                clubId: decodeToken(accessToken)['recent_club_id'],
                clubMemberId: decodeToken(accessToken)['club_member_id']);
        if (eulaValue == 'true') {
          if (MemberController.to.clubMember().isConfirmed) {
            Get.offNamed('/tab2', arguments: 1);
          } else {
            Get.offNamed('/club_list');
          }
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

      List<String> jwt = credential.identityToken?.split('.') ?? [];
      String payload = jwt[1];
      payload = base64.normalize(payload);

      final List<int> jsonData = base64.decode(payload);
      final userInfo = jsonDecode(utf8.decode(jsonData));
      print(userInfo);
      String tokenEmail = userInfo['email'];

      // 서버에 사용자 정보를 전송하고 애플 로그인 처리
      String email = credential.email ?? tokenEmail;
      String name =
          "${credential.givenName ?? "."} ${credential.familyName ?? "."}";

      await TokenApiService.postToken(email: email, name: name);
      await storage.write(key: loginInfo, value: '$email $name apple');

      try {
        eulaValue = await storage.read(key: eula);
      } catch (e) {
        print(e.toString());
      }

      // 로그인 성공 후 eula 동의 여부 확인 후 화면 전환
      if (eulaValue == 'true') {
        Get.offNamed('/club_list');
      } else {
        Get.offNamed('/eula');
      }
    } catch (e) {
      print(e.toString());
      snackBar(title: "애플 로그인에 실패했습니다", content: "잠시 후 다시 시도해 주세요");
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

        try {
          eulaValue = await storage.read(key: eula);
        } catch (e) {
          print(e.toString());
        }

        // 로그인 성공 후 eula 동의 여부 확인 후 화면 전환
        if (eulaValue == 'true') {
          Get.offNamed('/club_list');
        } else {
          Get.offNamed('/eula');
        }
      } catch (e) {
        print(e.toString());
        snackBar(title: "구글 로그인에 실패했습니다", content: "잠시 후 다시 시도해 주세요");
      }
    }
  }

  // 카카오 로그인
  Future<void> signInWithKakao() async {
    // 카카오 로그인 구현 예제

    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        await _onKakaoLoginSuccess(token);
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          snackBar(title: "카카오 로그인에 실패했습니다", content: "잠시 후 다시 시도해 주세요");
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          await _onKakaoLoginSuccess(token);
        } catch (error) {
          snackBar(title: "카카오 로그인에 실패했습니다", content: "잠시 후 다시 시도해 주세요");
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        await _onKakaoLoginSuccess(token);
      } catch (error) {
        snackBar(title: "카카오 로그인에 실패했습니다", content: "잠시 후 다시 시도해 주세요");
      }
    }
  }

  Future<void> _onKakaoLoginSuccess(OAuthToken token) async {
    try {
      User user = await UserApi.instance.me();

      String email = user.kakaoAccount!.email ?? ".";
      String name = user.kakaoAccount!.name ?? ".";
      await TokenApiService.postToken(email: email, name: name);
      await storage.write(key: loginInfo, value: '$email $name kakao');

      try {
        eulaValue = await storage.read(key: eula);
      } catch (e) {
        print(e.toString());
      }

      // 로그인 성공 후 eula 동의 여부 확인 후 화면 전환
      if (eulaValue == 'true') {
        Get.offNamed('/club_list');
      } else {
        Get.offNamed('/eula');
      }
    } catch (e) {
      print(e.toString());
      snackBar(title: "로그인에 실패했습니다", content: "잠시 후 다시 시도해 주세요");
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

        try {
          eulaValue = await storage.read(key: eula);
        } catch (e) {
          print(e.toString());
        }

        // 로그인 성공 후 eula 동의 여부 확인 후 화면 전환
        if (eulaValue == 'true') {
          Get.offNamed('/club_list');
        } else {
          Get.offNamed('/eula');
        }
      } catch (e) {
        print(e.toString());
        snackBar(title: "네이버 로그인에 실패했습니다", content: "잠시 후 다시 시도해 주세요");
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
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: SizeController.to.screenHeight * 0.22,
                              bottom: SizeController.to.screenHeight * 0.05),
                          child: SvgPicture.asset(
                            'assets/images/login/dplanner_logo_login.svg',
                          ),
                        ),

                        const Expanded(child: SizedBox()),

                        //카카오 로그인 버튼
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              SizeController.to.screenWidth * 0.07,
                              0,
                              SizeController.to.screenWidth * 0.07,
                              SizeController.to.screenHeight * 0.01),
                          child: ImageButton(
                              image: 'assets/images/login/login_kakao.png',
                              onTap: () async {
                                await signInWithKakao();
                              }),
                        ),

                        // 네이버 로그인 버튼
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              SizeController.to.screenWidth * 0.07,
                              0,
                              SizeController.to.screenWidth * 0.07,
                              SizeController.to.screenHeight * 0.01),
                          child: ImageButton(
                              image: 'assets/images/login/login_naver.png',
                              onTap: () async {
                                await signInWithNaver();
                              }),
                        ),

                        //구글 로그인 버튼
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              SizeController.to.screenWidth * 0.07,
                              0,
                              SizeController.to.screenWidth * 0.07,
                              0),
                          child: ImageButton(
                              image: 'assets/images/login/login_google.png',
                              onTap: () async {
                                await signInWithGoogle();
                              }),
                        ),
                        if (Platform.isIOS)
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                SizeController.to.screenWidth * 0.07,
                                SizeController.to.screenHeight * 0.01,
                                SizeController.to.screenWidth * 0.07,
                                0),
                            child: SignInWithAppleButton(
                              onPressed: () async {
                                await signInWithApple();
                              },
                            ),
                          ),
                        SizedBox(
                          height: SizeController.to.screenHeight * 0.1,
                        ),
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}
