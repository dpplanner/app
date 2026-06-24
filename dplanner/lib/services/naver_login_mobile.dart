import 'package:flutter_naver_login/flutter_naver_login.dart';

import 'naver_login_service.dart';

/// 모바일용: flutter_naver_login 사용.
Future<NaverAccount?> naverLogIn() async {
  final NaverLoginResult result = await FlutterNaverLogin.logIn();
  if (result.status == NaverLoginStatus.loggedIn) {
    return NaverAccount(result.account.email, result.account.name);
  }
  return null;
}

Future<void> naverLogOut() async {
  await FlutterNaverLogin.logOut();
}
