import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import '../../../model/common_response.dart';

FutureOr<dynamic> commonResponseBodyBindingInterceptor(
    Request request, Response response) async {
  print("response: ${response.body}");
  var responseBody = CommonResponseBody.fromJson(response.body);
  print("responseBody: $responseBody");

  if (response.hasError) {
    if (kDebugMode) {
      print("[API CALL FAIL] ${responseBody.message}");
    }
    throw Exception();
  }

  return CommonResponse(body: responseBody);
}
