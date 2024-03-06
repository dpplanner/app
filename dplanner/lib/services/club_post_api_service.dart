import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../const.dart';
import 'package:dplanner/models/post_model.dart';

class PostApiService {
  static const String baseUrl = 'http://3.39.102.31:8080';

  static Future<List<Post>> fetchPosts({required int clubID}) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(
      Uri.parse('$baseUrl/posts/clubs/$clubID?size=10&page=0'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> content = responseData['data']['content'];
      return content.map((data) => Post.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
