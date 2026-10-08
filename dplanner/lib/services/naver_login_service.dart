import 'naver_login_web.dart'
    if (dart.library.io) 'naver_login_mobile.dart' as impl;

/// 네이버 로그인 결과 계정 정보.
class NaverAccount {
  final String email;
  final String name;
  const NaverAccount(this.email, this.name);
}

/// 네이버 로그인. 성공 시 계정 정보, 실패/취소 시 null.
///
/// flutter_naver_login은 웹을 지원하지 않으므로 조건부 import로 분기한다.
/// 웹에서는 stub(naver_login_web.dart)이 호출되어 UnsupportedError를 던진다.
Future<NaverAccount?> naverLogIn() => impl.naverLogIn();

/// 네이버 로그아웃. 웹은 no-op.
Future<void> naverLogOut() => impl.naverLogOut();
