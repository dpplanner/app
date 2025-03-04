import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../const/const.dart';

class TokenApiService {
  static const String baseUrl = 'http://api.dplanner.co.kr';

  /// POST: /eula [eula 동의] eula 동의하기
  static Future<void> postEula() async {
    final url = Uri.parse('$baseUrl/eula');
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return;
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// POST: /auth/login [client login] 로그인 후 JWT 토큰 발급
  static Future<void> postToken(
      {required String email, required String name}) async {
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

      // secure storage에 Token 보관
      await storage.write(key: accessTokenKey, value: data['accessToken']);
      await storage.write(key: refreshTokenKey, value: data['refreshToken']);
      await storage.write(key: eula, value: data['eula'].toString());

      print(data['eula'].toString());
      print('new token saved');
      return;
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// POST: /auth/refresh [refresh token] JWT 토큰 재발급
  static Future<void> postUpdateToken() async {
    final url = Uri.parse('$baseUrl/auth/refresh');
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: accessTokenKey);
    String? refreshToken = await storage.read(key: refreshTokenKey);

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body)['data'];

      // 토큰 업데이트
      await storage.delete(key: accessTokenKey);
      await storage.delete(key: refreshTokenKey);
      await storage.write(key: accessTokenKey, value: data['accessToken']);
      await storage.write(key: refreshTokenKey, value: data['refreshToken']);

      print('token updated');
      return;
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// PATCH: /members/(_.member_id)/change-club [클럽 변경하기] 가입된 클럽 중 다른 클럽으로 이동
  static Future<void> patchUpdateClub(
      {required String memberId, required String clubId}) async {
    final url = Uri.parse('$baseUrl/members/$memberId/change-club');
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "clubId": clubId,
      }),
    );

    if (response.statusCode == 200) {
      await TokenApiService.postUpdateToken();
      return;
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }
}
