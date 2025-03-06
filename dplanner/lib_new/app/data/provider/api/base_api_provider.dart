import 'package:get/get.dart';

import '../../../utils/url_utils.dart';
import 'interceptors/authenticator.dart';
import 'interceptors/request_interceptor.dart';
import 'interceptors/response_interceptor.dart';

class BaseApiProvider extends GetConnect {
  static const String _baseUrl = 'http://api.dplanner.co.kr';

  @override
  void onInit() {
    httpClient.baseUrl = _baseUrl;
    httpClient.errorSafety = false;

    httpClient.addRequestModifier(authorizationHeaderRequestInterceptor);
    httpClient.addRequestModifier(loggingRequestInterceptor);

    httpClient.addResponseModifier(loggingResponseInterceptor);
    httpClient.addResponseModifier(commonResponseBodyBindingInterceptor);

    httpClient.addAuthenticator(refreshTokenAuthenticator);
  }

  Future<Response<T>> deleteWithBody<T>(
    String url,
    dynamic body, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) {
    var queryString = UrlUtils.toQueryString(query);
    return request(url + queryString, "DELETE",
        body: body,
        contentType: contentType,
        headers: headers,
        decoder: decoder);
  }
}
