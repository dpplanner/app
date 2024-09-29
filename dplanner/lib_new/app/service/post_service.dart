import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';

import '../data/model/paging_request.dart';
import '../data/model/post/like_status_type.dart';
import '../data/model/post/post.dart';
import '../data/model/post/post_like.dart';
import '../data/model/post/request/post_report_request.dart';
import '../data/model/post/request/post_request.dart';
import '../data/provider/api/post_api_provider.dart';
import '../utils/compress_utils.dart';
import 'club_member_service.dart';
import 'club_service.dart';

class PostService extends GetxService {
  final PostApiProvider postApiProvider = Get.find<PostApiProvider>();
  final ClubService clubService = Get.find<ClubService>();
  final ClubMemberService clubMemberService = Get.find<ClubMemberService>();

  Future<Post> getPost({required int postId}) async {
    return await postApiProvider.getPost(postId: postId);
  }

  Future<Post> createPost(
      {required Post post, required List<XFile>? images}) async {
    List<XFile> compressedImages = [];
    images?.forEach((image) async {
      var compressedImage = await CompressUtils.compressImageFile(image);
      compressedImages.add(compressedImage!);
    });

    return await postApiProvider.createPost(
        request: PostRequest.forCreate(post: post), images: compressedImages);
  }

  Future<Post> updatePost(
      {required Post post, required List<XFile>? images}) async {
    List<XFile> compressedImages = [];
    images?.forEach((image) async {
      var compressedImage = await CompressUtils.compressImageFile(image);
      compressedImages.add(compressedImage!);
    });

    return await postApiProvider.updatePost(
        postId: post.id,
        request: PostRequest.forUpdate(post: post),
        images: compressedImages);
  }

  void deletePost({required int postId}) async {
    return postApiProvider.deletePost(postId: postId);
  }

  Future<List<Post>> getPosts({required PagingRequest paging}) async {
    var currentClubId = await clubService.getCurrentClubId();
    return await postApiProvider.getPostsByClubId(
        clubId: currentClubId, paging: paging);
  }

  Future<List<Post>> getMyPosts({required PagingRequest paging}) async {
    var currentClubMemberId = await clubMemberService.getCurrentClubMemberId();
    return await postApiProvider.getPostsByClubMemberId(
        clubMemberId: currentClubMemberId, paging: paging);
  }

  Future<List<Post>> getCommentedPosts({required PagingRequest paging}) async {
    var currentClubMemberId = await clubMemberService.getCurrentClubMemberId();
    return await postApiProvider.getCommentedPostsByClubMemberId(
        clubMemberId: currentClubMemberId, paging: paging);
  }

  Future<List<Post>> getLikedPosts({required PagingRequest paging}) async {
    var currentClubMemberId = await clubMemberService.getCurrentClubMemberId();
    return await postApiProvider.getLikedPostsByClubMemberId(
        clubMemberId: currentClubMemberId, paging: paging);
  }

  void blockPost({required int postId}) async {
    postApiProvider.blockPost(postId: postId);
  }

  void reportPost(
      {required int postId, required PostReportRequest request}) async {
    postApiProvider.reportPost(postId: postId, request: request);
  }

  /// Admin
  Future<bool> fixPostToggle({required int postId}) async {
    Post post = await postApiProvider.fixPostToggle(postId: postId);
    return post.isFixed;
  }

  Future<bool> likePostToggle({required int postId}) async {
    PostLike postLikeDto = await postApiProvider.likePostToggle(postId: postId);
    return postLikeDto.likeStatus == LikeStatusType.LIKE;
  }
}
