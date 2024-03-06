import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../const.dart';
import 'package:dplanner/models/post_model.dart';
import 'package:dplanner/models/post_comment_model.dart';

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

  static Future<List<Comment>?> fetchComments(int postId) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(
      Uri.parse('$baseUrl/posts/$postId/comments'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData =
          jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> content = responseData['data'];

      if (content.isEmpty) {
        // 댓글이 없을 경우 null 반환
        return null;
      }

      // 댓글이 있으면 리스트로 변환하여 반환
      return content.map((data) => Comment.fromJson(data)).toList();
    } else {
      // HTTP 오류 발생 시 예외 처리
      throw Exception('Failed to load comments');
    }
  }

  static Future<bool> toggleLike(int postId) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);

    final url = Uri.parse('$baseUrl/posts/$postId/like');
    final headers = {
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.put(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data']['status'] == 'LIKE') {
          return true;
        } else if (data['data']['status'] == 'DISLIKE') {
          return false;
        }
      }
      throw Exception('Failed to toggle like');
    } catch (e) {
      throw Exception('Failed to toggle like: $e');
    }
  }
}
