import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_naver_login/interface/types/naver_login_result.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';

import 'naver_login_service.dart';

/// 모바일용: flutter_naver_login 사용.
Future<NaverAccount?> naverLogIn() async {
  final NaverLoginResult result = await FlutterNaverLogin.logIn();
  if (result.status == NaverLoginStatus.loggedIn) {
    final account = result.account;
    // 로그인 결과에 토큰이 없는 플랫폼이 있어 현재 토큰을 다시 조회한다
    final accessToken = result.accessToken?.accessToken.isNotEmpty == true
        ? result.accessToken!.accessToken
        : (await FlutterNaverLogin.getCurrentAccessToken()).accessToken;
    return NaverAccount(
        account?.email ?? '.', account?.name ?? '.', accessToken);
  }
  print('네이버 로그인 실패: ${result.status} ${result.errorMessage}');
  return null;
}

Future<void> naverLogOut() async {
  await FlutterNaverLogin.logOut();
}
