import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../const.dart';
import 'package:dplanner/models/post_model.dart';
import 'package:dplanner/models/post_comment_model.dart';

import '../pages/post_page.dart';

class PostApiService {
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

  static Future<Post?> submitPost(
      {required int clubId,
      required String title,
      required String content,
      List<XFile>? imageFileList}) async {
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

    // 이미지 파일이 있을 경우 멀티파트 파일로 추가
    if (imageFileList != null) {
      for (var imageFile in imageFileList) {
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
          print("${basename(compressedFile.path)}");
          formData.files.add(multipartFile);
        }
      }
    }

    try {
      final response = await formData.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 201) {
        // 요청이 성공한 경우
        final post = Post.fromJson(jsonDecode(utf8.decode(responseBody.bodyBytes))['data']);
        Get.snackbar('알림', '게시글이 작성되었습니다.');
        Get.off(() => PostPage(postId: post.id,), arguments: 1); // 게시글 등록 이후 바로 작성한 게시글로 이동
        return post;
      } else {
        // 요청이 실패한 경우
        Get.snackbar('알림',
            '게시글 작성에 실패했습니다. error: ${response.statusCode} ${responseBody.body}');
      }
    } catch (e) {
      // 요청 중 오류가 발생한 경우
      Get.snackbar('알림', '오류가 발생했습니다.');
    }
    return null;
  }

  static Future<List<Post>> fetchPosts(
      {required int clubID, required int page}) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(
      Uri.parse('$baseUrl/posts/clubs/$clubID?size=100&page=$page'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> content = responseData['data']['content'];
      return content.map((data) => Post.fromJson(data)).toList();
    } else {
      print(response.body);
      print(response.statusCode);
      throw Exception('Failed to load posts');
    }
  }

  static Future<List<Post>> fetchMyPosts(
      //TODO: 포스트 없을때
      {required int clubMemberID, required int page}) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(
      Uri.parse('$baseUrl/posts/clubMembers/$clubMemberID?size=100&page=$page'),
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

  static Future<List<Post>> fetchCommentedPosts(
      {required int clubMemberID, required int page}) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);

    //todo api 나오면 uri 바꾸기
    final response = await http.get(
      Uri.parse('$baseUrl/posts/clubMembers/$clubMemberID/commented?size=100&page=$page'),
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

  static Future<List<Post>> fetchLikedPosts(
      {required int clubMemberID, required int page}) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(
      Uri.parse('$baseUrl/posts/clubMembers/$clubMemberID/like?size=100&page=$page'),
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

  static Future<Post> fetchPost({required int postID}) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(
      Uri.parse('$baseUrl/posts/$postID'),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(utf8.decode(response.bodyBytes))['data']);
    } else {
      print(response.body);
      print(response.statusCode);
      throw Exception('Failed to load posts');
    }
  }

  static Future<Post?> editPost(
      {required int postID,
      required String title,
      required String content,
      List<XFile>? imageFileList,
      List<String>? previousImageFileList}) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);

    final url = Uri.parse('$baseUrl/posts/$postID');
    final headers = {'Authorization': 'Bearer  $accessToken'};
    final formData = http.MultipartRequest('PUT', url);
    formData.headers.addAll(headers);
    final jsonData = {
      'title': title,
      'content': content,
      'attachmentUrl': previousImageFileList,
    };
    final jsonPart = http.MultipartFile.fromString(
      'update',
      jsonEncode(jsonData),
      contentType: MediaType('application', 'json'),
    );

    formData.files.add(jsonPart);

    // 이미지 파일이 있을 경우 멀티파트 파일로 추가
    if (imageFileList != null) {
      for (var imageFile in imageFileList) {
        final compressedFile =
            await compressImageFile(imageFile); //이미지 퀄리티를 떨어뜨려 용량을 줄임
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
          print("${basename(compressedFile.path)}");
          formData.files.add(multipartFile);
        }
      }
    }

    try {
      final response = await formData.send();
      final responseBody = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        Get.back(); // 게시글 수정 페이지 나가기
        Get.back(); // 바텀 시트 닫기
        Get.snackbar('알림', '게시글이 수정되었습니다.');
        return Post.fromJson(jsonDecode(utf8.decode(responseBody.bodyBytes))['data']);
      } else {
        // 요청이 실패한 경우
        Get.snackbar('알림', '게시글 수정에 실패했습니다. error: ${response.statusCode}');
      }
    } catch (e) {
      // 요청 중 오류가 발생한 경우
      Get.snackbar('알림', '오류가 발생했습니다.');
    }
    return null;
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

  static Future<void> fixPost(int postId) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);

    final url = Uri.parse('$baseUrl/posts/$postId/fix');
    final headers = {
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.put(url, headers: headers);

      if (response.statusCode == 200) {
        Post result =
            Post.fromJson(jsonDecode(utf8.decode(response.bodyBytes))['data']);
        if (result.isFixed == true) {
          Get.back();
          Get.snackbar('알림', '이 게시글을 고정했습니다');
        } else {
          Get.back();
          Get.snackbar('알림', '이 게시글을 고정해제했습니다');
        }
        return; // 성공적으로 업데이트
      }
      throw Exception('Failed to toggle like');
    } catch (e) {
      throw Exception('Failed to toggle like: $e');
    }
  }

  static Future<void> reportPost({
    required int postId, required int clubMemberId, required String reportMessage}) async {
    try {
      // AccessToken 가져오기
      final storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: accessTokenKey);
      final url = Uri.parse('$baseUrl/posts/$postId/report');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final body = jsonEncode({
        "postId": postId,
        "clubMemberId": clubMemberId,
        "reportMessage": reportMessage,
      });

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      // 응답 확인
      if (response.statusCode == 200) {
        return;
      } else {
        throw Error();
      }
    } catch (e) {
      // 오류 처리
      print('오류 발생: $e');
    }
  }
}

class PostCommentApiService {
  static const String baseUrl = 'http://3.39.102.31:8080';

  static Future<void> postComment(
      {required int postId, required String content, int? parentId}) async {
    try {
      // AccessToken 가져오기
      final storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: accessTokenKey);
      final url = Uri.parse('$baseUrl/comments');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final body = jsonEncode({
        "postId": postId,
        "parentId": parentId,
        "content": content,
      });

      final response = await http.post(
        url,
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

  static Future<List<Comment>?> fetchMyComments(
      {required int clubMemberID}) async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: accessTokenKey);

    final response = await http.get(
      Uri.parse('$baseUrl/clubMembers/$clubMemberID/comments'),
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

  static Future<void> reportComment({
    required int commentId, required int clubMemberId, required String reportMessage}) async {
    try {
      // AccessToken 가져오기
      final storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: accessTokenKey);
      final url = Uri.parse('$baseUrl/comments/$commentId/report');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final body = jsonEncode({
        "commentId": commentId,
        "clubMemberId": clubMemberId,
        "reportMessage": reportMessage,
      });

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      // 응답 확인
      if (response.statusCode == 200) {
        return;
      } else {
        throw Error();
      }
    } catch (e) {
      // 오류 처리
      print('오류 발생: $e');
    }
  }
}
