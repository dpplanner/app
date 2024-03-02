import 'dart:convert';

import 'package:dplanner/services/token_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../const.dart';
import '../decode_token.dart';
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
      await TokenApiService.postUpdateToken();
      return ClubModel.fromJson(jsonDecode(response.body)['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// POST: /clubs/(_.club_id)/invite [클럽 초대하기 코드 생성] 클럽 초대 코드 생성
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

  /// POST: /clubs/(_.club_id)/updateClubImage [클럽 대표 이미지 변경] 클럽 대표 이미지 변경하기
  static Future<ClubModel> postClubImage(
      {required int clubId, required XFile? image}) async {
    final url = Uri.parse('$baseUrl/clubs/$clubId/updateClubImage');
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: accessTokenKey);

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $accessToken',
    });

    if (image != null) {
      var imageFile = await http.MultipartFile.fromPath('image', image.path);
      request.files.add(imageFile);
    }

    var response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      return ClubModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// GET: /clubs?memberId=(_.member_id) [내 클럽 목록] 내 클럽 목록 불러오기
  static Future<List<ClubModel>> getClubList() async {
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    String memberId = decodeToken(accessToken!)['sub'];

    final url = Uri.parse('$baseUrl/clubs?memberId=$memberId');

    final response = await http.get(url, headers: <String, String>{
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      List<ClubModel> clubList = [];

      List<dynamic> clubData =
          jsonDecode(utf8.decode(response.bodyBytes))['data'];
      for (var club in clubData) {
        clubList.add(ClubModel.fromJson(club));
      }
      return clubList;
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// GET: /clubs/join?code=(_.join_code) [클럽 초대 코드 verify] 클럽 초대코드로 클럽 ID 불러오기
  static Future<int> getJoinClub({required String clubCode}) async {
    final url = Uri.parse('$baseUrl/clubs/join?code=$clubCode');
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(url, headers: <String, String>{
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['data']['verify']) {
      return jsonDecode(response.body)['data']['clubId'];
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// GET: /clubs/(_.club_id) [클럽 상세 정보] 클럽 ID로 클럽 상세 정보 불러오기
  static Future<ClubModel> getClub({required int clubID}) async {
    final url = Uri.parse('$baseUrl/clubs/$clubID');
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(url, headers: <String, String>{
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return ClubModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// PATCH: /clubs/(_.club_id) [클럽 정보 수정] 클럽 정보 변경하기
  static Future<ClubModel> patchClub(
      {required int clubId, required String info}) async {
    final url = Uri.parse('$baseUrl/clubs/$clubId');
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({"info": info}),
    );

    if (response.statusCode == 200) {
      return ClubModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }
}
