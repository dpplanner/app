import 'dart:html' as html;

/// 웹: 해시 라우트(#/xxx)로 진입/새로고침한 경우 루트로 URL을 리셋한다.
/// history.state는 보존해야 Flutter 라우터의 "null history state" 크래시를 막는다.
void resetDeepLinkToRoot() {
  final loc = html.window.location;
  final hash = loc.hash;
  if (hash.isNotEmpty && hash != '#/' && hash != '#') {
    html.window.history.replaceState(
      html.window.history.state,
      '',
      loc.pathname,
    );
  }
}
