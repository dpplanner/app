import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../const.dart';
import '../models/reservation_model.dart';
import '../models/resource_model.dart';

class ReservationApiService {
  static const String baseUrl = 'http://3.39.102.31:8080';

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

  /// GET: /reservations?resourceId=(_.resource_id)&start=(_.start_datetime)&end=(_.end_datetime)&status=(_.status) [예약 목록 확인하기] 클럽 예약 목록 가져오기
  static Future<List<ReservationModel>> getReservations(
      {required int resourceId,
      required String startDateTime,
      required String endDateTime,
      required String status}) async {
    final url = Uri.parse(
        '$baseUrl/reservations?resourceId=$resourceId&start=$startDateTime&end=$endDateTime&status=$status');
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

  /// POST: /reservations/(_.reservation_id)/update [예약 수정 하기] 예약 수정 하기
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
