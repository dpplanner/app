import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../const/const.dart';
import '../decode_token.dart';

class MemberApiService {
  static const String baseUrl = 'http://3.39.102.31:8080';

  /// DELETE: /members/(_.member_id) [앱 탈퇴] 앱 탈퇴하기
  static Future<void> deleteMember() async {
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    String memberId = decodeToken(accessToken!)['sub'];
    final url = Uri.parse('$baseUrl/members/$memberId');

    final response = await http.delete(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return;
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }
}
