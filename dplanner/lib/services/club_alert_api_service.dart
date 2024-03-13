import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dplanner/const.dart';
import 'package:http/http.dart' as http;
import 'package:dplanner/models/club_alert_message_model.dart';
import 'dart:convert';

class ClubAlertApiService {
  static const String baseUrl = 'http://3.39.102.31:8080';

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
        final List<dynamic> responseData = json.decode(response.body);
        final List<AlertMessageModel> alertList = responseData
            .map((json) => AlertMessageModel.fromJson(json))
            .toList();
        return alertList;
      }
      throw Exception('Failed to connect to the server');
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}
