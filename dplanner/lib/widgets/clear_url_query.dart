import 'clear_url_query_stub.dart'
    if (dart.library.html) 'clear_url_query_web.dart' as impl;

/// 웹에서 현재 URL의 쿼리스트링(예: 카카오 redirect의 ?code=...)을 제거한다.
/// (모바일은 no-op)
void clearUrlQuery() => impl.clearUrlQuery();
