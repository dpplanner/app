import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import '../../../../support/exceptions.dart';
import '../../../model/common_response.dart';

FutureOr<dynamic> commonResponseBodyBindingInterceptor(
    Request request, Response response) async {
  if (response.hasError) {
    if (kDebugMode) {
      var responseBody = CommonResponseBody.fromJson(response.body);
      print("[API CALL FAIL] ${request.url} ${responseBody.message} ");
    }

    if (response.request!.url.toString().endsWith("/auth/refresh")) {
      // /auth/refresh 요청이 실패하면 throw
      throw TokenRefreshFailedException();
    }
  }
  return CommonResponse.from(response);
}

FutureOr<dynamic> loggingResponseInterceptor(
    Request request, Response response) async {
  if (kDebugMode) {
    print(
        "\n>>> RESPONSE ${response.statusCode} ${response.statusText} ${request.url}"
        "\n  -H ${response.headers}"
        "\n  -d ${response.bodyString}\n");
  }
  return response;
}
