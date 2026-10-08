import 'naver_login_service.dart';

/// 웹용 stub: flutter_naver_login은 웹을 지원하지 않는다.
/// (로그인 버튼은 웹에서 숨겨지므로 정상 흐름에서는 호출되지 않는다.)
Future<NaverAccount?> naverLogIn() async {
  throw UnsupportedError('네이버 로그인은 웹에서 지원되지 않습니다.');
}

Future<void> naverLogOut() async {
  // 웹은 네이버 SDK를 사용하지 않으므로 별도 처리 없음
}
