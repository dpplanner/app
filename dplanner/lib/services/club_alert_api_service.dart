import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dplanner/const.dart';
import 'package:http/http.dart' as http;
import 'package:dplanner/models/club_alert_message_model.dart';
import 'dart:convert';
import 'package:dplanner/decode_token.dart';

class ClubAlertApiService {
  static const String baseUrl = 'http://3.39.102.31:8080';

  static void refreshFCMToken(String? fcmToken) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);
    String memberID = decodeToken(accessToken!)['sub'];

    final url = Uri.parse('$baseUrl/members/$memberID/refreshFcmToken');
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };

    final body = jsonEncode({"refreshFcmToken": fcmToken});

    try {
      final response = await http.patch(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print("yesssssssssss");
      }
    } catch (e) {
      throw Exception("faillll");
    }
  }

  static Future<List<AlertMessageModel>> fetchAlertList() async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);

    final url = Uri.parse('$baseUrl/messages');
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> content = responseData['data']['responseList'];
        return content.map((data) => AlertMessageModel.fromJson(data)).toList();
      }
      throw Exception('Failed to connect to the server');
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<void> markAsRead(int messageID) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);

    final url =
        Uri.parse('$baseUrl/messages/$messageID'); // 예시 URL, 실제 API에 맞게 조정 필요
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.patch(url, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to mark message as read');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
