import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import '../../../../service/secure_storage_service.dart';

FutureOr<Request> authorizationHeaderRequestInterceptor(Request request) async {
  final secureStorageService = Get.find<SecureStorageService>();
  String? accessToken = await secureStorageService.getAccessToken();

  if (accessToken != null) {
    request.headers['Authorization'] = 'Bearer $accessToken';
  }

  return request;
}

FutureOr<Request> loggingRequestInterceptor(Request request) async {
  if (kDebugMode) {
    var bodyString =
        request.headers["content-type"]!.startsWith("multipart/form-data")
            ? "multipart-file"
            : await request.bodyBytes.bytesToString();

    print("\n<<< REQUEST: ${request.method.toUpperCase()} ${request.url}"
        "\n  -H ${request.headers}"
        "\n  -d $bodyString\n");
  }
  return request;
}
