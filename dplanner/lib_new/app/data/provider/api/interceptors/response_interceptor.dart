import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import '../../../model/common_response.dart';

FutureOr<dynamic> responseInterceptor(
    Request request, Response response) async {

  if (response.hasError) {
    _handleErrorStatus(response);
    return;
  }

  final json = jsonDecode(utf8.decode(response.body));
  return CommonResponse.fromJson(json);
}

void _handleErrorStatus(Response response) {
  final json = jsonDecode(utf8.decode(response.body));
  var responseBody = CommonResponse.fromJson(json);

  if (kDebugMode) {
    print(responseBody.message);
  }

  // 인증 만료 케이스의 경우 여기에서 토큰 갱신 후 다시 요청 할 수 있도록 시도해볼 예정(가능할지는 모름)
  switch(response.statusCode) {
    case 400:
      break;
    case 401:
      break;
    case 403:
      break;
    case 500:
      break;
    default:
      break;
  }
  return;
}