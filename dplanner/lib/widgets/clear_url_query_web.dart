import 'dart:html' as html;

/// 웹용: 쿼리스트링을 제거하고 경로+해시만 남긴다.
void clearUrlQuery() {
  final path = html.window.location.pathname ?? '/';
  final hash = html.window.location.hash ?? '';
  // state를 null로 덮으면 Flutter 라우터 상태(serialCount)가 사라져
  // 이후 네비게이션에서 "unexpected null history state"로 크래시난다.
  // 기존 state를 그대로 유지한 채 URL(쿼리)만 교체한다.
  html.window.history
      .replaceState(html.window.history.state, '', '$path$hash');
}
