import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../const.dart';
import '../models/resource_model.dart';

class ResourceApiService {
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
}
