import 'package:get/get.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/response_interceptor.dart';

class BaseApiProvider extends GetConnect {
  static const String _baseUrl = 'http://3.39.102.31:8080';

  @override
  void onInit() {
    httpClient.baseUrl = _baseUrl;
    httpClient.addAuthenticator(authInterceptor);
    httpClient.addResponseModifier(responseInterceptor);
  }
}