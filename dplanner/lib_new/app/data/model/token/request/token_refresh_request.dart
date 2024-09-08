import '../../json_serializable.dart';

class TokenRefreshRequest extends JsonSerializable {
  String accessToken;
  String refreshToken;

  TokenRefreshRequest({
    required this.accessToken,
    required this.refreshToken});

  @override
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken
    };
  }
}