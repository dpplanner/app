import 'naver_login_web.dart'
    if (dart.library.io) 'naver_login_mobile.dart' as impl;

/// 네이버 로그인 결과 계정 정보.
class NaverAccount {
  final String email;
  final String name;
  final String accessToken;
  const NaverAccount(this.email, this.name, this.accessToken);
}

/// 네이버 로그인 실패 종류.
enum NaverLoginFailure {
  /// 사용자가 취소 (SDK가 error로 넘긴 경우)
  cancelled,

  /// 네트워크 연결·네이버 서버 일시 오류
  network,

  /// 네이버가 오류 코드와 함께 거절 (동의 거부 등)
  failed,

  /// SDK·플러그인 자체 오류 (초기화·토큰 조회 실패 등)
  sdk,
}

/// 네이버 로그인 실패. [message]는 로그용 원문.
class NaverLoginException implements Exception {
  final NaverLoginFailure failure;
  final String message;
  const NaverLoginException(this.failure, this.message);

  @override
  String toString() => 'NaverLoginException($failure): $message';
}

/// 네이버 로그인. 성공 시 계정 정보, 사용자 취소 시 null,
/// 실패 시 [NaverLoginException]을 던진다.
///
/// flutter_naver_login은 웹을 지원하지 않으므로 조건부 import로 분기한다.
/// 웹에서는 stub(naver_login_web.dart)이 호출되어 UnsupportedError를 던진다.
Future<NaverAccount?> naverLogIn() => impl.naverLogIn();

/// 네이버 로그아웃. 웹은 no-op.
Future<void> naverLogOut() => impl.naverLogOut();
