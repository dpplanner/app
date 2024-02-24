import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dplanner/models/user_model.dart';

class UserApiService {
  static const String baseUrl = 'http://3.39.102.31:8080';

  /// POST: /auth/login [client login] 로그인 후 access token, refresh token 발급
  static Future<void> postUserLogin(String email, String name) async {
    final url = Uri.parse('$baseUrl/auth/login');
    const storage = FlutterSecureStorage();

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "email": email,
        "name": name,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body)['data'];

      String accessToken = data['accessToken'];
      String refreshToken = data['refreshToken'];

      // 토큰 업데이트
      dynamic userInfo = await storage.read(key: 'login');
      if (userInfo != null) {
        await storage.delete(key: 'login');
      }

      // 시스템 저장소에 토큰 저장; 자동로그인인 경우 email과 password도 저장
      // var loginValue = autoLogin
      //     ? jsonEncode({"token": token, "email": email, "password": password})
      //     : jsonEncode({"token": token});
      // await storage.write(key: 'login', value: loginValue);

      print(accessToken);
      print(refreshToken);
      print('token updated');
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }
}
