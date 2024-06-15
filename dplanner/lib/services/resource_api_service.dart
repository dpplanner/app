import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../const/const.dart';
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
      required String resourceType,
      required int bookableSpan}) async {
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
        "bookableSpan": bookableSpan,
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

  /// GET: /resources [클럽 자원 목록 가져오기] 클럽 전체 자원 목록 가져오기
  static Future<List<List<ResourceModel>>> getResources() async {
    final url = Uri.parse('$baseUrl/resources');
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      List<ResourceModel> resourceListPlace = [];
      List<ResourceModel> resourceListThing = [];

      List<dynamic> resourceData =
          jsonDecode(utf8.decode(response.bodyBytes))['data'];
      for (var resource in resourceData) {
        if (resource['resourceType'] == "PLACE") {
          resourceListPlace.add(ResourceModel.fromJson(resource));
        } else {
          resourceListThing.add(ResourceModel.fromJson(resource));
        }
      }
      return [resourceListPlace, resourceListThing];
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
      required String resourceType,
      required int bookableSpan}) async {
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
        "bookableSpan": bookableSpan
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
