import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';

import '../../model/common_response.dart';
import '../../model/paging_request.dart';
import '../../model/paging_response.dart';
import '../../model/post/post.dart';
import '../../model/post/post_like.dart';
import '../../model/post/request/post_report_request.dart';
import '../../model/post/request/post_request.dart';
import 'base_api_provider.dart';

class PostApiProvider extends BaseApiProvider {
  Future<Post> getPost({required int postId}) async {
    var response = await get("/posts/$postId") as CommonResponse;
    return Post.fromJson(response.data);
  }

  Future<Post> createPost(
      {required PostRequest request, required List<XFile>? images}) async {
    var formData = FormData({});

    formData.fields.addAll(request
        .toJson()
        .entries
        .map((entry) => MapEntry(entry.key, entry.value.toString()))
        .toList());

    formData.files.addAll(images!
        .map((image) =>
            MapEntry("file", MultipartFile(image, filename: image.name)))
        .toList());

    var response = await post("/posts", formData) as CommonResponse;
    return Post.fromJson(response.data);
  }

  Future<Post> updatePost(
      {required int postId,
      required PostRequest request,
      required List<XFile>? images}) async {
    var formData = FormData({});

    formData.fields.addAll(request
        .toJson()
        .entries
        .map((entry) => MapEntry(entry.key, entry.value.toString()))
        .toList());

    formData.files.addAll(images!
        .map((image) =>
            MapEntry("file", MultipartFile(image, filename: image.name)))
        .toList());

    var response = await put("/posts/$postId", formData) as CommonResponse;
    return Post.fromJson(response.data);
  }

  void deletePost({required int postId}) async {
    await delete("/posts/$postId");
  }

  Future<List<Post>> getPostsByClubId(
      {required int clubId, required PagingRequest paging}) async {
    var response = await get("/posts/clubs/$clubId", query: paging.toJson())
        as CommonResponse;
    var pagingResponse = response.data as PagingResponse;
    var jsonList = pagingResponse.content as List<Map<String, dynamic>>;

    return jsonList.map((message) => Post.fromJson(message)).toList();
  }

  Future<List<Post>> getPostsByClubMemberId(
      {required int clubMemberId, required PagingRequest paging}) async {
    var response =
        await get("/posts/clubMembers/$clubMemberId", query: paging.toJson())
            as CommonResponse;
    var pagingResponse = response.data as PagingResponse;
    var jsonList = pagingResponse.content as List<Map<String, dynamic>>;

    return jsonList.map((message) => Post.fromJson(message)).toList();
  }

  Future<List<Post>> getCommentedPostsByClubMemberId(
      {required int clubMemberId, required PagingRequest paging}) async {
    var response = await get("/posts/clubMembers/$clubMemberId/commented",
        query: paging.toJson()) as CommonResponse;
    var pagingResponse = response.data as PagingResponse;
    var jsonList = pagingResponse.content as List<Map<String, dynamic>>;

    return jsonList.map((message) => Post.fromJson(message)).toList();
  }

  Future<List<Post>> getLikedPostsByClubMemberId(
      {required int clubMemberId, required PagingRequest paging}) async {
    var response = await get("/posts/clubMembers/$clubMemberId/like",
        query: paging.toJson()) as CommonResponse;
    var pagingResponse = response.data as PagingResponse;
    var jsonList = pagingResponse.content as List<Map<String, dynamic>>;

    return jsonList.map((message) => Post.fromJson(message)).toList();
  }

  Future<Post> fixPostToggle({required int postId}) async {
    var response = await put("/posts/$postId/fix", null) as CommonResponse;
    return Post.fromJson(response.data);
  }

  Future<PostLike> likePostToggle({required int postId}) async {
    var response = await put("/posts/$postId/like", null) as CommonResponse;
    return PostLike.fromJson(response.data);
  }

  void blockPost({required int postId}) async {
    await post("/posts/$postId/block", null);
  }

  void reportPost(
      {required int postId, required PostReportRequest request}) async {
    await post("/posts/$postId/report", request.toJson());
  }
}
