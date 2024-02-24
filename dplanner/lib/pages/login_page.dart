import 'dart:convert';
import 'dart:io';

import 'package:dplanner/widgets/image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../services/user_api_service.dart';
import '../style.dart';
import '../controllers/size.dart';

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_naver_login/flutter_naver_login.dart';

enum LoginPlatform { kakao, naver, google, none }

GoogleSignIn googleSignIn = GoogleSignIn();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginPlatform _loginPlatform = LoginPlatform.none;

  @override
  void initState() {
    super.initState();
    checkUserLogin();
  }

  void checkUserLogin() async {
    // 1.5초간 대기
    await Future.delayed(const Duration(milliseconds: 1500));

    // 로그인 상태 확인
    const storage = FlutterSecureStorage();
    String? userInfoString = await storage.read(key: 'login');
    int? isBelongedFamily;
    // if (userInfoString != null) {
    //   Map<String, dynamic> userInfo = json.decode(userInfoString);
    //   if (userInfo['email'] != null) {
    //     // 자동 로그인 상태; 토큰 정보 자동으로 다시 받아오기
    //     try {
    //       await UserApiService.postUserLogin(
    //           userInfo['email'], userInfo['password']);
    //     } catch (e) {
    //       // TODO: 에러 팝업 추가
    //       print(e.toString());
    //     }
    //     if (isBelongedFamily == 1) {
    //       // 가족이 있는 경우
    //       Navigator.pushReplacement(context,
    //           MaterialPageRoute(builder: (context) => const RootPage()));
    //     } else if (isBelongedFamily == 0) {
    //       // 가족이 없는 경우
    //       Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(
    //               builder: (context) => const FamilyJoinCreatePage()));
    //     }
    //   } else {
    //     // 자동 로그인 X
    //     Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (context) => const LoginSignUpPage()));
    //   }
    // } else {
    //   // 최초 로그인 상태
    //   Navigator.pushReplacement(context,
    //       MaterialPageRoute(builder: (context) => const LoginSignUpPage()));
    // }

    FlutterNativeSplash.remove();
  }

  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    try {
      await UserApiService.postUserLogin(
          googleUser!.email, googleUser.displayName ?? "이름없음");
    } catch (e) {
      // TODO: 에러 내용 알려주기
      print(e.toString());
    }

    if (googleUser != null) {
      print("accessToken =${googleUser.serverAuthCode}");
      print('id = ${googleUser.id}');
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');

      setState(() {
        _loginPlatform = LoginPlatform.google;
      });
    }
  }

  void signInWithKakao() async {
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
      print("accessToken =${token.toString()}");
      print("ci =${user.kakaoAccount!.ci}");
      print("name =${user.kakaoAccount!.name}");
      print("email =${user.kakaoAccount!.email}");

      setState(() {
        _loginPlatform = LoginPlatform.kakao;
      });
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
  }

  void signInWithNaver() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status == NaverLoginStatus.loggedIn) {
      print('accessToken = ${result.accessToken}');
      print('id = ${result.account.id}');
      print('name = ${result.account.name}');
      print('email = ${result.account.email}');

      setState(() {
        _loginPlatform = LoginPlatform.naver;
      });
    }
  }

  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.google:
        await GoogleSignIn().signOut();
        break;
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        break;
      case LoginPlatform.naver:
        await FlutterNaverLogin.logOut();
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
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
              SizedBox(height: SizeController.to.screenHeight * 0.1),
              SvgPicture.asset(
                'assets/images/login/dplanner_logo_login.svg',
              ),
              SizedBox(height: SizeController.to.screenHeight * 0.3),

              ///TODO: 이미지 변경 필요
              ImageButton(
                  image: 'assets/images/login/kakao_login.svg',
                  onTap: () {
                    signInWithKakao();
                    //Get.offNamed('/club_list');
                  }),
              SizedBox(height: SizeController.to.screenHeight * 0.005),
              ImageButton(
                  image: 'assets/images/login/naver_login.svg',
                  onTap: () {
                    signInWithNaver();
                  }),
              SizedBox(height: SizeController.to.screenHeight * 0.005),
              ImageButton(
                  image: 'assets/images/login/facebook_login.svg',
                  onTap: () {
                    signInWithGoogle();
                  }),
              TextButton(
                  onPressed: () {
                    signOut();
                  },
                  child: Text("로그아웃"))
            ],
          ),
        ),
      ),
    );
  }
}
