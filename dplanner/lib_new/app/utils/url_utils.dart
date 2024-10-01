class UrlUtils {
  static const String _https = "https://";
  static const String _file = "file:///";

  static String toHttps(String? url) {
    if (url == null) return "";

    if (url.startsWith(_file)) {
      url = url.replaceFirst(_file, "");
    }

    if (!url.startsWith(_https)) {
      url = _https + url;
    }

    return url;
  }

  static String toQueryString(Map<String, dynamic>? query) {
    if (query == null) return "";

    var queryList =
        query.entries.map((e) => "${e.key}=${e.value.toString()}").toList();
    return "?${queryList.join("&")}";
  }
}
