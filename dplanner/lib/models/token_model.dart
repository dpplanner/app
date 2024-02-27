// 사용 x

class TokenModel {
  final String accessToken, refreshToken;

  TokenModel({required this.accessToken, required this.refreshToken});

  TokenModel.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        refreshToken = json['refreshToken'];
}
