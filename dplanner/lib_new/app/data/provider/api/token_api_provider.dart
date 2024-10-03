import '../../model/common_response.dart';
import '../../model/token/request/token_create_request.dart';
import '../../model/token/request/token_refresh_request.dart';
import '../../model/token/response/token_response.dart';
import 'base_api_provider.dart';

class TokenApiProvider extends BaseApiProvider {
  Future<TokenResponse> issueToken(TokenIssueRequest request) async {
    var response =
        await post('/auth/login', request.toJson()) as CommonResponse;

    return TokenResponse.fromJson(response.body!.data!);
  }

  Future<TokenResponse> refreshToken(
      {required TokenRefreshRequest request}) async {
    var response =
        await post('/auth/refresh', request.toJson()) as CommonResponse;
    return TokenResponse.fromJson(response.body!.data!);
  }
}
