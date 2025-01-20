import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../config/routings/routes.dart';
import '../../../service/services.dart';
import '../../../utils/token_utils.dart';
import '../../base/widgets/snackbar.dart';

class LoginController extends GetxController {
  final TokenService _tokenService = Get.find<TokenService>();
  final ClubMemberService _clubMemberService = Get.find<ClubMemberService>();
  final SecureStorageService _secureStorageService =
      Get.find<SecureStorageService>();

  // 로그인 상태 확인
  Future<void> checkUserLogin() async {
    try {
      String? accessToken = await _secureStorageService.getAccessToken();
      if (accessToken != null && TokenUtils.validateToken(token: accessToken)) {
        // accessToken이 유효하면 통과
        return await processAutoLogin(accessToken);
      }

      String? refreshToken = await _secureStorageService.getRefreshToken();
      if (refreshToken != null &&
          TokenUtils.validateToken(token: refreshToken)) {
        // accessToken이 만료됨 & refreshToken이 유효함 -> 토큰 갱신 후 통과
        await _tokenService.refreshToken();
        accessToken = await _secureStorageService.getAccessToken();
        return await processAutoLogin(accessToken!);
      }
    } catch (e) {
      print(e);
    } finally {
      FlutterNativeSplash.remove();
    }
  }

  // 자동 로그인
  Future<void> processAutoLogin(String accessToken) async {
    try {
      bool? eulaAgreed = await _secureStorageService.getEulaAgreed();
      if (_isEulaAgreed(eulaAgreed)) {
        var clubMember = await _clubMemberService.getMyInfo();
        if (clubMember.isConfirmed) {
          Get.offNamed(Routes.POST_LIST, arguments: 1);
        } else {
          Get.offNamed(Routes.CLUB_LIST);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  // 카카오 로그인
  Future<void> loginWithKakao() async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        await _onKakaoLoginSuccess(token);
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        if (error is PlatformException && error.code == 'CANCELED') {
          snackBar(title: "카카오 로그인에 실패했습니다", content: "잠시 후 다시 시도해 주세요");
          return;
        }

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

  // 네이버 로그인
  Future<void> loginWithNaver() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status == NaverLoginStatus.loggedIn) {
      try {
        String email = result.account.email;
        String name = result.account.name;
        await _afterLoginSuccess(email: email, name: name, loginType: "naver");
      } catch (e) {
        print(e.toString());
        snackBar(title: "네이버 로그인에 실패했습니다", content: "잠시 후 다시 시도해 주세요");
      }
    }
  }

  // 구글 로그인
  Future<void> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      try {
        String email = googleUser.email;
        String name = googleUser.displayName ?? ".";

        await _afterLoginSuccess(email: email, name: name, loginType: "google");
      } catch (e) {
        print(e.toString());
        snackBar(title: "구글 로그인에 실패했습니다", content: "잠시 후 다시 시도해 주세요");
      }
    }
  }

  // 애플 로그인
  Future<void> loginWithApple() async {
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

      await _afterLoginSuccess(email: email, name: name, loginType: "apple");
    } catch (e) {
      print(e.toString());
      snackBar(title: "애플 로그인에 실패했습니다", content: "잠시 후 다시 시도해 주세요");
    }
  }

  /// private methods
  bool _isEulaAgreed(bool? eulaAgreed) =>
      eulaAgreed != null && eulaAgreed == true;

  Future<void> _onKakaoLoginSuccess(OAuthToken token) async {
    try {
      User user = await UserApi.instance.me();

      String email = user.kakaoAccount!.email ?? ".";
      String name = user.kakaoAccount!.name ?? ".";
      await _afterLoginSuccess(email: email, name: name, loginType: "kakao");
    } catch (e) {
      print(e.toString());
      snackBar(title: "로그인에 실패했습니다", content: "잠시 후 다시 시도해 주세요");
    }
  }

  Future<void> _afterLoginSuccess(
      {required String email, required String name, required loginType}) async {
    await _tokenService.issueToken(email: email, name: name);
    await _secureStorageService.writeLoginInfo(
        email: email, name: name, type: loginType);

    bool? eulaAgreed = await _secureStorageService.getEulaAgreed();

    // 로그인 성공 후 eula 동의 여부 확인 후 화면 전환
    if (_isEulaAgreed(eulaAgreed)) {
      Get.offNamed(Routes.CLUB_LIST);
    } else {
      Get.offNamed(Routes.EULA_AGREE);
    }
  }
}
