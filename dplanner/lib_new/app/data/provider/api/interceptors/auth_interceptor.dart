import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import '../../../../service/auth/secure_storage_service.dart';

FutureOr<Request> authInterceptor(request) async {
  final secureStorageService = Get.find<SecureStorageService>();
  String? accessToken = await secureStorageService.getAccessToken();

  if (accessToken != null) {
    request.headers['Authorization'] = 'Bearer $accessToken';
  }

  return request;
}