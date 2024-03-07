import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:get/get.dart';

import '../const.dart';
import 'package:dplanner/models/post_model.dart';
import 'package:dplanner/models/post_comment_model.dart';

class PostApiService {
  static const String baseUrl = 'http://3.39.102.31:8080';

  static Future<void> submitPost({
    required int clubId,
    required String title,
    required String content,
  }) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);

    final url = Uri.parse('$baseUrl/posts');
    final headers = {
      'Authorization': 'Bearer $accessToken',
    };
    final formData = http.MultipartRequest('POST', url);
    formData.headers.addAll(headers);
    final jsonData = {
      'clubId': clubId,
      'title': title,
      'content': content,
    };
    final jsonPart = http.MultipartFile.fromString(
      'create',
      jsonEncode(jsonData),
      contentType: MediaType('application', 'json'),
    );

    formData.files.add(jsonPart);

    try {
      final response = await formData.send();

      if (response.statusCode == 201) {
        Get.back();
        // 요청이 성공한 경우
        Get.snackbar('알림', '게시글이 작성되었습니다.');
      } else {
        // 요청이 실패한 경우
        Get.snackbar('알림', '게시글 작성에 실패했습니다. error: ${response.statusCode}');
      }
    } catch (e) {
      // 요청 중 오류가 발생한 경우
      Get.snackbar('알림', '오류가 발생했습니다.');
    }
  }

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

  static Future<void> editPost({
    required int postID,
    required String title,
    required String content,
  }) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);

    final url = Uri.parse('$baseUrl/posts/$postID');
    final headers = {'Authorization': 'Bearer  $accessToken'};
    final formData = http.MultipartRequest('PUT', url);
    formData.headers.addAll(headers);
    final jsonData = {
      'title': title,
      'content': content,
      'attachmentUrl': [],
    };
    final jsonPart = http.MultipartFile.fromString(
      'update',
      jsonEncode(jsonData),
      contentType: MediaType('application', 'json'),
    );

    formData.files.add(jsonPart);

    try {
      final response = await formData.send();

      if (response.statusCode == 200) {
        Get.back();
        Get.snackbar('알림', '게시글이 수정되었습니다.');
      } else {
        // 요청이 실패한 경우
        Get.snackbar('알림', '게시글 수정에 실패했습니다. error: ${response.statusCode}');
      }
    } catch (e) {
      // 요청 중 오류가 발생한 경우
      Get.snackbar('알림', '오류가 발생했습니다.');
    }
  }

  static Future<void> deletePost(int postId) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);

    final url = Uri.parse('$baseUrl/posts/$postId');
    final headers = {
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode == 204) {
        return; // 성공적으로 삭제되면 아무것도 반환하지 않음
      } else {
        throw Exception('Failed to delete post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete post: $e');
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

class PostCommentApiService {
  static const String baseUrl = 'http://3.39.102.31:8080';

  static Future<void> postComment({
    required int postId,
    required String content,
  }) async {
    try {
      // AccessToken 가져오기
      final storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: accessTokenKey);

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final body = jsonEncode({
        "postId": postId,
        "parentId": null,
        "content": content,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/comments'),
        headers: headers,
        body: body,
      );

      // 응답 확인
      if (response.statusCode == 201) {
        // 성공한 경우
        Get.snackbar('알림', '댓글이 성공적으로 게시되었습니다.');
      } else {
        // 실패한 경우
        Get.snackbar('알림', '댓글 게시에 실패했습니다. 에러 코드: ${response.statusCode}');
      }
    } catch (e) {
      // 오류 처리
      print('오류 발생: $e');
    }
  }

  static Future<void> deleteComment(int commentID) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);

    final url = Uri.parse('$baseUrl/comments/$commentID');
    final headers = {
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode == 204) {
        // 삭제 성공
        Get.snackbar('알림', '댓글이 성공적으로 삭제되었습니다.');
      } else {
        // 삭제 실패
        Get.snackbar('알림', '댓글 삭제를 실패했습니다. 에러 코드: ${response.statusCode}');
      }
    } catch (e) {
      // 요청 중 오류 발생
      print('댓글 삭제 중 오류가 발생했습니다. 오류: $e');
    }
  }

  static Future<void> postReplyComment(
      int postId, int parentId, String content) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);
    final url = Uri.parse('$baseUrl/comments');
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    final body = {
      'postId': postId,
      'parentId': parentId,
      'content': content,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode == 201) {
        // 답댓글 작성 성공
        Get.snackbar('알림', '답댓글이 성공적으로 게시되었습니다.');
      } else {
        // 답댓글 작성 실패
        Get.snackbar('알림', '답댓글 작성에 실패했습니다. 에러 코드: ${response.statusCode}');
      }
    } catch (e) {
      // 요청 중 오류 발생
      print('답댓글 작성 중 오류가 발생했습니다. 오류: $e');
    }
  }
}
