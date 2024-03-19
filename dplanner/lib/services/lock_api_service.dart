import 'dart:convert';

import 'package:dplanner/models/lock_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../const.dart';
import '../models/resource_model.dart';

class LockApiService {
  static const String baseUrl = 'http://3.39.102.31:8080';

  /// POST: /locks/resources/(_.resource_id) [락 생성하기] 예약 락 생성하기
  static Future<LockModel> postLock(
      {required int resourceId,
      required String startDateTime,
      required String endDateTime,
      required String message}) async {
    final url = Uri.parse('$baseUrl/locks/resources/$resourceId');
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "startDateTime": startDateTime,
        "endDateTime": endDateTime,
        "message": message
      }),
    );

    if (response.statusCode == 201) {
      return LockModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// GET: /resources [클럽 자원 목록 가져오기] 클럽 전체 자원 목록 가져오기
  static Future<List<LockModel>> getLocks(
      {required int resourceId,
      required String startDateTime,
      required String endDateTime}) async {
    final url = Uri.parse(
        '$baseUrl/locks/resources/$resourceId?startDateTime=$startDateTime&endDateTime=$endDateTime');
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      List<LockModel> lockList = [];

      List<dynamic> lockData =
          jsonDecode(utf8.decode(response.bodyBytes))['data'];
      for (var lock in lockData) {
        lockList.add(LockModel.fromJson(lock));
      }
      return lockList;
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
