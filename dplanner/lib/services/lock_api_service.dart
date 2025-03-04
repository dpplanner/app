import 'dart:convert';

import 'package:dplanner/models/lock_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../const/const.dart';

class LockApiService {
  static const String baseUrl = 'http://api.dplanner.co.kr';

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

  /// PUT: /locks/(_.lock_id) [락 수정하기] 예약 락 수정하기
  static Future<LockModel> putLock(
      {required int lockId,
      required int resourceId,
      required String startDateTime,
      required String endDateTime,
      required String message}) async {
    final url = Uri.parse('$baseUrl/locks/$lockId');
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "resourceId": resourceId,
        "startDateTime": startDateTime,
        "endDateTime": endDateTime,
        "message": message
      }),
    );

    if (response.statusCode == 200) {
      return LockModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// DELETE: /locks/(_.lock_id) [락 삭제하기] 예약 락 삭제하기
  static Future<void> deleteLock({required int lockId}) async {
    final url = Uri.parse('$baseUrl/locks/$lockId');
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
