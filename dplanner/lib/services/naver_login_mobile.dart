import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_naver_login/interface/types/naver_login_result.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';

import 'naver_login_service.dart';

/// 모바일용: flutter_naver_login 사용.
Future<NaverAccount?> naverLogIn() async {
  final NaverLoginResult result = await FlutterNaverLogin.logIn();
  if (result.status == NaverLoginStatus.loggedIn) {
    final account = result.account;
    return NaverAccount(account?.email ?? '.', account?.name ?? '.');
  }
  return null;
}

Future<void> naverLogOut() async {
  await FlutterNaverLogin.logOut();
}
