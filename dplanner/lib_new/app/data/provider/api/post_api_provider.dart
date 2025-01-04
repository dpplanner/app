import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../utils/url_utils.dart';
import '../../model/common_response.dart';
import '../../model/paging_request.dart';
import '../../model/paging_response.dart';
import '../../model/post/post.dart';
import '../../model/post/post_like.dart';
import '../../model/post/request/post_report_request.dart';
import '../../model/post/request/post_request.dart';
import 'support/form_data_factory.dart';
import 'base_api_provider.dart';

class PostApiProvider extends BaseApiProvider {
  Future<Post> getPost({required int postId}) async {
    var response = await get("/posts/$postId") as CommonResponse;
    return Post.fromJson(response.body!.data!!);
  }

  Future<Post> createPost(
      {required PostRequest request, required List<XFile>? images}) async {
    var formData = await FormDataFactory.create({
      "create": request,
      "files": images
    });

    var response = await post("/posts", formData) as CommonResponse;
    return Post.fromJson(response.body!.data!!);
  }

  Future<Post> updatePost(
      {required int postId,
      required PostRequest request,
      required List<XFile>? images}) async {
    var formData = await FormDataFactory.create({
      "update": request,
      "files": images
    });

    var response = await put("/posts/$postId", formData) as CommonResponse;
    return Post.fromJson(response.body!.data!);
  }

  Future<void> deletePost({required int postId}) async {
    await delete("/posts/$postId");
  }

  Future<List<Post>> getPostsByClubId(
      {required int clubId, required PagingRequest paging}) async {
    var queryString = UrlUtils.toQueryString(paging.toJson());
    var response =
        await get("/posts/clubs/$clubId$queryString") as CommonResponse;
    var pagingResponse = PagingResponse.fromJson(response.body!.data);

    return pagingResponse.content
        .map((message) => Post.fromJson(message))
        .toList();
  }

  Future<List<Post>> getPostsByClubMemberId(
      {required int clubMemberId, required PagingRequest paging}) async {
    var queryString = UrlUtils.toQueryString(paging.toJson());
    var response = await get("/posts/clubMembers/$clubMemberId$queryString")
        as CommonResponse;
    var pagingResponse = PagingResponse.fromJson(response.body!.data);

    return pagingResponse.content
        .map((message) => Post.fromJson(message))
        .toList();
  }

  Future<List<Post>> getCommentedPostsByClubMemberId(
      {required int clubMemberId, required PagingRequest paging}) async {
    var queryString = UrlUtils.toQueryString(paging.toJson());
    var response =
        await get("/posts/clubMembers/$clubMemberId/commented$queryString")
            as CommonResponse;
    var pagingResponse = PagingResponse.fromJson(response.body!.data);

    return pagingResponse.content
        .map((message) => Post.fromJson(message))
        .toList();
  }

  Future<List<Post>> getLikedPostsByClubMemberId(
      {required int clubMemberId, required PagingRequest paging}) async {
    var queryString = UrlUtils.toQueryString(paging.toJson());
    var response =
        await get("/posts/clubMembers/$clubMemberId/like$queryString")
            as CommonResponse;
    var pagingResponse = PagingResponse.fromJson(response.body!.data);

    return pagingResponse.content
        .map((message) => Post.fromJson(message))
        .toList();
  }

  Future<Post> fixPostToggle({required int postId}) async {
    var response = await put("/posts/$postId/fix", null) as CommonResponse;
    return Post.fromJson(response.body!.data!);
  }

  Future<PostLike> likePostToggle({required int postId}) async {
    var response = await put("/posts/$postId/like", null) as CommonResponse;
    return PostLike.fromJson(response.body!.data!);
  }

  Future<void> blockPost({required int postId}) async {
    await post("/posts/$postId/block", null);
  }

  Future<void> reportPost(
      {required int postId, required PostReportRequest request}) async {
    await post("/posts/$postId/report", request.toJson());
  }
}
