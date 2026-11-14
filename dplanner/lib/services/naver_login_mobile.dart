import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_naver_login/interface/types/naver_login_result.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';

import 'naver_login_service.dart';

/// 모바일용: flutter_naver_login 사용.
///
/// 플러그인 결과: 성공 = loggedIn, 사용자 취소 = loggedOut,
/// 그 외 실패 = error (errorMessage에 "errorCode:..., errorDesc:..." 형식).
Future<NaverAccount?> naverLogIn() async {
  final NaverLoginResult result;
  try {
    result = await FlutterNaverLogin.logIn();
  } catch (e) {
    throw NaverLoginException(NaverLoginFailure.sdk, e.toString());
  }

  if (result.status == NaverLoginStatus.loggedIn) {
    final account = result.account;
    // 로그인 결과에 토큰이 없는 플랫폼이 있어 현재 토큰을 다시 조회한다
    String accessToken;
    try {
      accessToken = result.accessToken?.accessToken.isNotEmpty == true
          ? result.accessToken!.accessToken
          : (await FlutterNaverLogin.getCurrentAccessToken()).accessToken;
    } catch (e) {
      throw NaverLoginException(NaverLoginFailure.sdk, e.toString());
    }
    if (accessToken.isEmpty) {
      throw const NaverLoginException(NaverLoginFailure.sdk, '액세스 토큰 없음');
    }
    return NaverAccount(
        account?.email ?? '.', account?.name ?? '.', accessToken);
  }

  if (result.status == NaverLoginStatus.loggedOut) {
    print('네이버 로그인 취소: ${result.errorMessage}');
    return null;
  }

  final message = result.errorMessage ?? '';
  print('네이버 로그인 실패: ${result.status} $message');
  throw NaverLoginException(_classify(message), message);
}

/// 네이버 SDK 오류 코드로 실패 종류를 나눈다.
NaverLoginFailure _classify(String message) {
  if (message.contains('user_cancel')) return NaverLoginFailure.cancelled;
  if (message.contains('connection_error') ||
      message.contains('temporarily_unavailable') ||
      message.contains('server_error')) {
    return NaverLoginFailure.network;
  }
  if (message.contains('errorCode:')) return NaverLoginFailure.failed;
  // 오류 코드 형식이 아니면 SDK/플러그인 단계 오류
  return NaverLoginFailure.sdk;
}

Future<void> naverLogOut() async {
  await FlutterNaverLogin.logOut();
}
