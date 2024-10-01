class TokenResponse {
  String accessToken;
  String refreshToken;
  bool? eulaAgreed;

  TokenResponse(
      {required this.accessToken,
      required this.refreshToken,
      required this.eulaAgreed});

  TokenResponse.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        refreshToken = json['refreshToken'],
        eulaAgreed = json['eula'];
}
