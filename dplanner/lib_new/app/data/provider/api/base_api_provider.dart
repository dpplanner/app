import 'package:get/get.dart';

import '../../../../config/const/api_constants.dart';
import 'interceptors/auth_interceptor.dart';

class BaseApiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;
    httpClient.addAuthenticator(authInterceptor);
  }
}