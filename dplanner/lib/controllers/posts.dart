import 'package:dplanner/models/post_model.dart';
import 'package:dplanner/services/club_post_api_service.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  static PostController get to => Get.find();

  RxList<Rx<Post>> posts = <Rx<Post>>[].obs;

  Rx<Post>? getRxPost(int postId) {
    return posts.firstWhereOrNull((rxPost) => rxPost.value.id == postId);
  }

  Future<void> blockPost(int postId) async {
    await PostApiService.postBlock(postID: postId);
    posts.removeWhere((post) => post.value.id == postId);
  }

  Future<void> fetchPosts(int clubId, int page) async {
    List<Post> fetchedPosts =
        await PostApiService.fetchPosts(clubID: clubId, page: page);
    posts.value = fetchedPosts.map((post) => post.obs).toList();
  }

  Future<void> fetchMyPosts(int clubMemberId, int page) async {
    List<Post> fetchedPosts = await PostApiService.fetchMyPosts(
        clubMemberID: clubMemberId, page: page);
    posts.value = fetchedPosts.map((post) => post.obs).toList();
  }

  Future<void> fetchCommentedPosts(int clubMemberId, int page) async {
    List<Post> fetchedPosts = await PostApiService.fetchCommentedPosts(
        clubMemberID: clubMemberId, page: page);
    posts.value = fetchedPosts.map((post) => post.obs).toList();
  }

  Future<void> fetchLikedPosts(int clubMemberId, int page) async {
    List<Post> fetchedPosts = await PostApiService.fetchLikedPosts(
        clubMemberID: clubMemberId, page: page);
    posts.value = fetchedPosts.map((post) => post.obs).toList();
  }

  Future<void> fetchPost(int postId) async {
    Post post = await PostApiService.fetchPost(postID: postId);
    getRxPost(postId)!.value = post;
    posts.refresh();
  }

  Future<void> createPost(
      {required int clubId,
      required String title,
      required String content,
      List<XFile>? imageFileList}) async {
    Post? post = await PostApiService.submitPost(
        clubId: clubId,
        title: title,
        content: content,
        imageFileList: imageFileList);

    if (post != null) {
      await fetchPosts(post.clubId, 0);
    }
  }

  Future<void> updatePost(
      {required int postId,
      required String title,
      required String content,
      List<XFile>? imageFileList,
      List<String>? previousImageFileList}) async {
    Post? post = await PostApiService.editPost(
        postID: postId,
        title: title,
        content: content,
        imageFileList: imageFileList,
        previousImageFileList: previousImageFileList);

    if (post != null) {
      getRxPost(postId)!.value = post;
      posts.refresh();
    }
  }

  Future<void> deletePost(int postId) async {
    await PostApiService.deletePost(postId);
    posts.removeWhere((rxPost) => rxPost.value.id == postId);
    update();
  }

  Future<void> toggleLike(Rx<Post> post) async {
    bool likeStatus = await PostApiService.toggleLike(post.value.id);

    post.value.likeStatus = likeStatus;
    if (likeStatus) {
      post.value.likeCount++;
    } else {
      post.value.likeCount--;
    }

    posts.refresh();
  }

  Future<void> fixPost(int postId) async {
    await PostApiService.fixPost(postId);
    fetchPosts(posts[0].value.clubId, 0);
  }
}
