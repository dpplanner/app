import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import '../../../../base/exceptions.dart';
import '../../../model/common_response.dart';

FutureOr<dynamic> commonResponseBodyBindingInterceptor(
    Request request, Response response) async {
  if (response.hasError) {
    var responseBody = CommonResponseBody.fromJson(response.body);

    if (kDebugMode) {
      // 디버그 모드 에서만 로깅
      print("[API CALL FAIL] ${request.url} ${responseBody.message} ");
    }

    if (response.request!.url.toString().endsWith("/auth/refresh")) {
      // /auth/refresh 요청이 실패시 throw
      throw TokenRefreshFailedException();
    }

    // 400번대, 500번대 에러 -> GetHttpException 예외 throw 후 상위 레이어에서 catch 해서 공통처리
    throw GetHttpException(responseBody.message ?? "API Call Failed");
  }

  // 성공한 경우 response 변환
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
