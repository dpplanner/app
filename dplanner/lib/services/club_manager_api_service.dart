import 'dart:convert';

import 'package:dplanner/models/club_manager_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../const/const.dart';

class ClubManagerApiService {
  static const String baseUrl = 'http://api.dplanner.co.kr';

  /// POST: /clubs/(_.club_id)/authorities [클럽 매니저 권한 생성] 클럽 매니저 권한 생성하기
  static Future<ClubManagerModel> postClubManager(
      {required int clubId,
      required String name,
      required String description,
      required List<dynamic> authorities}) async {
    final url = Uri.parse('$baseUrl/clubs/$clubId/authorities');
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
        "clubId": clubId,
        "description": description,
        "authorities": authorities,
      }),
    );

    if (response.statusCode == 200) {
      return ClubManagerModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// GET: /clubs/(_.club_id)/authorities [클럽 매니저 권한 목록] 클럽 매니저 권한 목록 가져오기
  static Future<List<ClubManagerModel>> getClubManager(
      {required int clubId}) async {
    final url = Uri.parse('$baseUrl/clubs/$clubId/authorities');
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(url, headers: <String, String>{
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      List<ClubManagerModel> clubManagerList = [];
      List<dynamic> clubManagerData =
          jsonDecode(utf8.decode(response.bodyBytes))['data'];
      for (var manager in clubManagerData) {
        clubManagerList.add(ClubManagerModel.fromJson(manager));
      }
      return clubManagerList;
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// PUT: /clubs/(_.club_id)/authorities [클럽 매니저 권한 수정] 클럽 매니저 권한 수정하기
  static Future<ClubManagerModel> putClubManager(
      {required int id,
      required int clubId,
      required String name,
      required String description,
      required List<dynamic> authorities}) async {
    final url = Uri.parse('$baseUrl/clubs/$clubId/authorities');
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "id": id,
        "name": name,
        "clubId": clubId,
        "description": description,
        "authorities": authorities,
      }),
    );

    if (response.statusCode == 200) {
      return ClubManagerModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// DELETE: /clubs/(_.club_id)/authorities [클럽 매니저 삭제] 클럽 매니저 삭제하기
  static Future<void> deleteManager(
      {required int clubId, required int id}) async {
    final url = Uri.parse('$baseUrl/clubs/$clubId/authorities');
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({"id": id}),
    );

    if (response.statusCode == 200) {
      return;
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }
}
