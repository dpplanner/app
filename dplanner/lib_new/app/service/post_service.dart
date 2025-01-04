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
      {required int clubId,
      required String title,
      required String content,
      List<XFile>? images}) async {
    return await postApiProvider.createPost(
        request: PostRequest.forCreate(
            clubId: clubId, title: title, content: content),
        images: await _compressImages(images));
  }

  Future<Post> updatePost(
      {required Post post, required List<XFile>? images}) async {
    return await postApiProvider.updatePost(
        postId: post.id,
        request: PostRequest.forUpdate(post: post),
        images: await _compressImages(images));
  }

  Future<void> deletePost({required int postId}) async {
    await postApiProvider.deletePost(postId: postId);
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

  Future<void> blockPost({required int postId}) async {
    await postApiProvider.blockPost(postId: postId);
  }

  Future<void> reportPost(
      {required int postId, required PostReportRequest request}) async {
    await postApiProvider.reportPost(postId: postId, request: request);
  }

  Future<bool> likePostToggle({required int postId}) async {
    PostLike postLikeDto = await postApiProvider.likePostToggle(postId: postId);
    return postLikeDto.likeStatus == LikeStatusType.LIKE;
  }

  /// Admin
  Future<bool> fixPostToggle({required int postId}) async {
    Post post = await postApiProvider.fixPostToggle(postId: postId);
    return post.isFixed;
  }

  /// private
  Future<List<XFile>> _compressImages(List<XFile>? images) async {
    List<XFile> compressedImages = [];
    if (images != null) {
      for (var image in images) {
        compressedImages.add((await CompressUtils.compressImageFile(image))!);
      }
    }
    return compressedImages;
  }
}
