import 'dart:html' as html;
import 'dart:js_util' as js_util;

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
    // 새로고침으로 딥 화면에 재진입한 경우 표시 → 스플래시를 조금 더 유지해
    // 자동로그인+딥 화면 렌더(폰트 FOUT)까지 가리게 한다. (index.html에서 사용)
    js_util.setProperty(html.window, 'dpWasDeepLink', true);
  }
}
