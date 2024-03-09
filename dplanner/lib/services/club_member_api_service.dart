import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../const.dart';
import '../models/club_member_model.dart';

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

  /// POST: /clubs/(_.club_id)/club-members/(_.club_member_id)/update-profile-image [클럽 멤버 프로필 이미지 변경] 클럽 멤버 프로필 이미지 변경하기
  static Future<ClubMemberModel> postProfile(
      {required int clubId,
      required int clubMemberId,
      required XFile? image}) async {
    final url = Uri.parse(
        '$baseUrl/clubs/$clubId/club-members/$clubMemberId/update-profile-image');
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
      return ClubMemberModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// GET: /clubs/(_.club_id)/club-members [클럽 멤버 목록] 클럽 멤버 목록 불러오기
  static Future<List<ClubMemberModel>> getClubMemberList(
      {required int clubId, required bool confirmed}) async {
    ///TODO: API 수정 요청
    final url = confirmed
        ? Uri.parse('$baseUrl/clubs/$clubId/club-members')
        : Uri.parse('$baseUrl/clubs/$clubId/club-members?confirmed=$confirmed');
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(url, headers: <String, String>{
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      List<ClubMemberModel> clubMemberList = [];

      List<dynamic> clubMemberData =
          jsonDecode(utf8.decode(response.bodyBytes))['data'];
      for (var clubMember in clubMemberData) {
        clubMemberList.add(ClubMemberModel.fromJson(clubMember));
      }
      return clubMemberList;
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// GET: /clubs/(_.club_id)/club-members/(_.club_member_id) [클럽 멤버 상세정보] 클럽 멤버 상세 정보 불러오기
  static Future<ClubMemberModel> getClubMember(
      {required int clubId, required int clubMemberId}) async {
    final url = Uri.parse('$baseUrl/clubs/$clubId/club-members/$clubMemberId');
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

  /// PATCH: /clubs/(_.club_id)/club-members/(_.club_member_id) [클럽 멤버 상세 정보 변경] 클럽 멤버 상세 정보 변경하기
  static Future<ClubMemberModel> patchClubMember(
      {required int clubMemberId,
      required int clubId,
      required String name,
      required String info}) async {
    final url = Uri.parse('$baseUrl/clubs/$clubId/club-members/$clubMemberId');
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({"name": name, "info": info}),
    );

    if (response.statusCode == 200) {
      return ClubMemberModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// PATCH: /clubs/(_.club_id)/club-members/confirm [클럽 멤버 승인] 클럽 멤버로 승인하기
  static Future<void> patchMemberToClub(
      {required int clubMemberId, required int clubId}) async {
    final url = Uri.parse('$baseUrl/clubs/$clubId/club-members/confirm');
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({"id": clubMemberId}),
    );

    if (response.statusCode == 204) {
      return;
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// PATCH: /clubs/(_.club_id)/club-members/(_.club_member_id)/role [클럽 멤버 권한 및 롤 변경] 클럽 멤버 등급 변경하기
  static Future<ClubMemberModel> patchAuthorities(
      {required int clubMemberId,
      required int clubId,
      required String role,
      required int? clubAuthorityId}) async {
    final url =
        Uri.parse('$baseUrl/clubs/$clubId/club-members/$clubMemberId/role');
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({"role": role, "clubAuthorityId": clubAuthorityId}),
    );

    if (response.statusCode == 200) {
      return ClubMemberModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// DELETE: /clubs/(_.club_id)/club-members/(_.club_member_id)/kickout [클럽 멤버 퇴출] 클럽 멤버 퇴출하기
  static Future<void> deleteClubMember(
      {required int clubId, required int clubMemberId}) async {
    final url =
        Uri.parse('$baseUrl/clubs/$clubId/club-members/$clubMemberId/kickout');
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
