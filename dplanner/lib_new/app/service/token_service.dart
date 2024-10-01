import 'package:get/get.dart';

import '../data/model/token/request/token_create_request.dart';
import '../data/model/token/request/token_refresh_request.dart';
import '../data/model/token/response/token_response.dart';
import '../data/provider/api/token_api_provider.dart';
import 'secure_storage_service.dart';

class TokenService extends GetxService {

  final TokenApiProvider tokenApiProvider = Get.find<TokenApiProvider>();
  final SecureStorageService secureStorageService = Get.find<SecureStorageService>();

  void issueToken({required String email, required String name}) async {
    var request = TokenIssueRequest(email: email, name: name);
    TokenResponse response = await tokenApiProvider.issueToken(request);

    secureStorageService.writeAccessToken(response.accessToken);
    secureStorageService.writeRefreshToken(response.refreshToken);
    secureStorageService.writeEulaAgreed(response.eulaAgreed!);
  }

  void refreshToken() async {
    String? accessToken = await secureStorageService.getAccessToken();
    String? refreshToken = await secureStorageService.getRefreshToken();

    var request = TokenRefreshRequest(accessToken: accessToken!, refreshToken: refreshToken!);
    TokenResponse response = await tokenApiProvider.refreshToken(request: request);
    await secureStorageService.updateAccessToken(response.accessToken);
    await secureStorageService.updateRefreshToken(response.refreshToken);
  }
}