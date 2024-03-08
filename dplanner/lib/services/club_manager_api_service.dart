import 'dart:convert';

import 'package:dplanner/models/club_manager_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../const.dart';
import '../models/resource_model.dart';

class ClubManagerApiService {
  static const String baseUrl = 'http://3.39.102.31:8080';

  /// POST: /resources [자원 생성하기] 클럽 자원 생성하기
  static Future<ResourceModel> postResource(
      {required int clubId,
      required String name,
      required String info,
      required bool returnMessageRequired,
      required String notice,
      required String resourceType}) async {
    final url = Uri.parse('$baseUrl/resources');
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
        "clubId": clubId,
        "returnMessageRequired": returnMessageRequired,
        "notice": notice,
        "resourceType": resourceType,
      }),
    );

    if (response.statusCode == 201) {
      return ResourceModel.fromJson(
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

  /// PUT: /resources/(_.resource_id) [클럽 자원 정보 업데이트] 클럽 자원 수정하기
  static Future<ResourceModel> putResource(
      {required int id,
      required String name,
      required String info,
      required bool returnMessageRequired,
      required String notice,
      required String resourceType}) async {
    final url = Uri.parse('$baseUrl/resources/$id');
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
        "info": info,
        "returnMessageRequired": returnMessageRequired,
        "notice": notice,
        "resourceType": resourceType,
      }),
    );

    if (response.statusCode == 200) {
      return ResourceModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// DELETE: /resources/(_.resource_id) [클럽 자원 삭제] 클럽 자원 삭제하기
  static Future<void> deleteResource({required int resourceId}) async {
    final url = Uri.parse('$baseUrl/resources/$resourceId');
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.delete(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 204) {
      return;
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }
}
