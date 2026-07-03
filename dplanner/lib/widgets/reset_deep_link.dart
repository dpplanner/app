import 'reset_deep_link_stub.dart'
    if (dart.library.html) 'reset_deep_link_web.dart' as impl;

/// 웹에서 내부 라우트(#/tab2 등)로 새로고침하면 로그인/자동로그인 흐름을 건너뛰어
/// 컨트롤러 상태가 비어 크래시난다. 앱 시작 시 루트('/')로 리셋해
/// 항상 초기 흐름을 타게 한다. (모바일은 no-op)
void resetDeepLinkToRoot() => impl.resetDeepLinkToRoot();
