import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import '../../../../base/exceptions.dart';
import '../../../../service/token_service.dart';

FutureOr<Request> refreshTokenAuthenticator(request) async {
  final tokenService = Get.find<TokenService>();

  try {
    await tokenService.refreshToken();
  } catch(e) {
    throw UnAuthorizedException();
  }

  return request;
}