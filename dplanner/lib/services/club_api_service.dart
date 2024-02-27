import 'dart:convert';

import 'package:dplanner/services/user_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../const.dart';
import '../models/club_model.dart';

class ClubApiService {
  static const String baseUrl = 'http://3.39.102.31:8080';

  /// POST: /clubs [클럽 생성] 클럽 생성
  static Future<ClubModel> postClub(
      {required String clubName, required String info}) async {
    final url = Uri.parse('$baseUrl/clubs');
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "clubName": clubName,
        "info": info,
      }),
    );

    if (response.statusCode == 201) {
      await UserApiService.postRefreshUserToken();
      return ClubModel.fromJson(jsonDecode(response.body)['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// POST: /clubs/(_.club_id)/invite [클럽 초대하기 코드 생성] 클럽 초대하기 코드 생성
  static Future<String> postClubCode({required int clubId}) async {
    final url = Uri.parse('$baseUrl/clubs/$clubId/invite');
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.post(url, headers: <String, String>{
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data']['inviteCode'];
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }
}
