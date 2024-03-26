import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

import '../const.dart';
import '../models/reservation_model.dart';

class ReservationApiService {
  static const String baseUrl = 'http://3.39.102.31:8080';

  static String basename(String filePath) {
    return filePath.split('/').last;
  }

  Future<String> getTempDirectoryPath() async {
    Directory tempDir = await getTemporaryDirectory();
    return tempDir.path;
  }

  static Future<XFile?> compressImageFile(XFile file) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;

    // 압축된 파일의 새 경로를 지정합니다.
    final outPath = "${tempPath}/${DateTime.now().millisecondsSinceEpoch}.jpg";

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.path,
      outPath,
      quality: 80, // 값을 조정하여 압축률을 제어할 수 있습니다.
    );

    // 'XFile' 객체로 변환하여 반환합니다.
    return compressedFile != null ? XFile(compressedFile.path) : null;
  }

  /// POST: /reservations [예약하기] 예약하기
  static Future<ReservationModel> postReservation(
      {required int resourceId,
      required String title,
      required String usage,
      required bool sharing,
      required String startDateTime,
      required String endDateTime,
      required List<dynamic> reservationInvitees}) async {
    final url = Uri.parse('$baseUrl/reservations');
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "resourceId": resourceId,
        "title": title,
        "usage": usage,
        "sharing": sharing,
        "startDateTime": startDateTime,
        "endDateTime": endDateTime,
        "reservationInvitees": reservationInvitees
      }),
    );

    if (response.statusCode == 200) {
      return ReservationModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// POST: /reservations/(_.reservation_id)/return [예약 반납하기] 예약 반납하기
  static Future<ReservationModel> postReturn(
      {required int reservationId,
      required String returnMessage,
      required List<XFile> returnImage}) async {
    final url = Uri.parse('$baseUrl/reservations/$reservationId/return');
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: accessTokenKey);

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $accessToken',
    });
    final jsonData = {
      'reservationId': reservationId,
      'returnMessage': returnMessage,
    };
    final jsonPart = http.MultipartFile.fromString(
      'returnDto',
      jsonEncode(jsonData),
      contentType: MediaType('application', 'json'),
    );

    request.files.add(jsonPart);

    for (var imageFile in returnImage) {
      final compressedFile = await compressImageFile(imageFile); //이미지 압축~!
      if (compressedFile != null) {
        final stream = http.ByteStream(compressedFile.openRead());
        stream.cast();
        final length = await compressedFile.length();
        final multipartFile = http.MultipartFile(
          'files',
          stream,
          length,
          filename: basename(compressedFile.path),
        );
        request.files.add(multipartFile);
      }
    }

    var response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      return ReservationModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['detail'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// GET: /reservations/(_.reservation_id) [예약 상세 정보 확인하기] 클럽 예약 상세 정보 확인하기
  static Future<ReservationModel> getReservation(
      {required int reservationId}) async {
    final url = Uri.parse('$baseUrl/reservations/$reservationId');
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      return ReservationModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// GET: /reservations/scheduler?resourceId=(_.resource_id)&start=(_.start_datetime)&end=(_.end_datetime) [스케줄러용 : 예약 목록] 클럽 예약 목록 가져오기
  static Future<List<ReservationModel>> getReservations(
      {required int resourceId,
      required String startDateTime,
      required String endDateTime}) async {
    final url = Uri.parse(
        '$baseUrl/reservations/scheduler?resourceId=$resourceId&start=$startDateTime&end=$endDateTime');
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      List<ReservationModel> reservationList = [];

      List<dynamic> reservationData =
          jsonDecode(utf8.decode(response.bodyBytes))['data'];
      for (var reservation in reservationData) {
        reservationList.add(ReservationModel.fromJson(reservation));
      }
      return reservationList;
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// GET: /reservations/admin?clubId=(_.club_id)&status=(_.status)&page=(_.page) [관리자용 : 예약 목록] 관리자용 예약 목록 가져오기
  static Future<List<ReservationModel>> getAdminReservations(
      {required int clubId, required int page, required String status}) async {
    final url = Uri.parse(
        '$baseUrl/reservations/admin?clubId=$clubId&status=$status&page=$page');
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      List<ReservationModel> reservationList = [];

      List<dynamic> reservationData =
          jsonDecode(utf8.decode(response.bodyBytes))['data']['content'];
      for (var reservation in reservationData) {
        reservationList.add(ReservationModel.fromJson(reservation));
      }
      return reservationList;
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// GET: /reservations/my-reservations?status=(_.status)&page=(_.page) [내 예약 목록 가져오기] 내 예약 목록 가져오기
  static Future<List<ReservationModel>> getMyReservations(
      {required int page, required String status}) async {
    final url = Uri.parse(
        '$baseUrl/reservations/my-reservations?status=$status&page=$page');
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    });

    if (response.statusCode == 200) {
      List<ReservationModel> reservationList = [];

      List<dynamic> reservationData =
          jsonDecode(utf8.decode(response.bodyBytes))['data']['content'];
      for (var reservation in reservationData) {
        reservationList.add(ReservationModel.fromJson(reservation));
      }
      return reservationList;
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// PUT: /reservations/(_.reservation_id)/update [예약 수정 하기] 예약 수정 하기
  static Future<ReservationModel> putReservation(
      {required int reservationId,
      required int resourceId,
      required String title,
      required String usage,
      required bool sharing,
      required String startDateTime,
      required String endDateTime,
      required List<dynamic> reservationInvitees}) async {
    final url = Uri.parse('$baseUrl/reservations/$reservationId/update');
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
        "title": title,
        "usage": usage,
        "sharing": sharing,
        "startDateTime": startDateTime,
        "endDateTime": endDateTime,
        "reservationInvitees": reservationInvitees
      }),
    );

    if (response.statusCode == 200) {
      return ReservationModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes))['data']);
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// PATCH: /reservations?confirm=(_.isConfirmed) [예약 Confirm하기] 클럽 예약 승인 & 거절하기
  static Future<void> patchReservation(
      {required List<int?> reservationIds, required bool isConfirmed}) async {
    final url = Uri.parse('$baseUrl/reservations?confirm=$isConfirmed');
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    List<Map<String, int?>> reservations =
        reservationIds.map((id) => {"reservationId": id}).toList();

    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(reservations),
    );

    if (response.statusCode == 204) {
      return;
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// PATCH: /reservations/(_.reservation_id)/cancel [예약 취소하기] 클럽 예약 취소하기
  static Future<void> cancelReservation({required int reservationId}) async {
    final url = Uri.parse('$baseUrl/reservations/$reservationId/cancel');
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "reservationId": reservationId,
      }),
    );

    if (response.statusCode == 204) {
      return;
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }

  /// DELETE: /reservations [예약 삭제하기] 클럽 예약 삭제하기
  static Future<void> deleteReservation({required int reservationId}) async {
    final url = Uri.parse('$baseUrl/reservations');
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);

    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "reservationId": reservationId,
      }),
    );

    if (response.statusCode == 204) {
      return;
    }

    // 예외 처리; 메시지를 포함한 예외를 던짐
    String errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
    print(errorMessage);
    throw ErrorDescription(errorMessage);
  }
}
