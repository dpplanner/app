import 'dart:convert';

import 'package:dplanner/services/user_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../const.dart';
import '../decode_token.dart';
import '../models/club_member_model.dart';
import '../models/club_model.dart';

class ClubMemberApiService {
  static const String baseUrl = 'http://3.39.102.31:8080';

  /// POST: /clubs/(_.club_id)/join [클럽 가입하기] 클럽 멤버 가입하기
  static Future<ClubMemberModel> postClubMember(
      {required int clubId, required String name, required String info}) async {
    final url = Uri.parse('$baseUrl/clubs/$clubId/join');
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "name": name,
        "info": info,
      }),
    );

    if (response.statusCode == 201) {
      return ClubMemberModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// GET: /clubs/(_.club_id)/club-members/(_.club_member_id) [클럽 멤버 상세정보] 클럽 멤버 상세 정보 불러오기
  static Future<ClubMemberModel> getClubMember(
      {required int clubId, required int clubMemberID}) async {
    final url = Uri.parse('$baseUrl/clubs/$clubId/club-members/$clubMemberID');
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(url, headers: <String, String>{
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return ClubMemberModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }
}
