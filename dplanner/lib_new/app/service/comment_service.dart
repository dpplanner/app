import 'package:get/get.dart';

import '../data/model/comment/comment.dart';
import '../data/model/comment/request/comment_report_request.dart';
import '../data/model/comment/request/comment_request.dart';
import '../data/provider/api/comment_api_provider.dart';

class CommentService extends GetxService {
  final CommentApiProvider commentApiProvider = Get.find<CommentApiProvider>();

  Future<List<Comment>> getComments({required int postId}) async {
    return await commentApiProvider.getComments(postId: postId);
  }

  Future<Comment> createComment(
      {required int postId, required String content, int? parentId}) async {
    return await commentApiProvider.createComment(
        request: CommentRequest.forCreate(
            postId: postId, parentId: parentId, content: content));
  }

  Future<Comment> updateComment(
      {required int commentId, required Comment comment}) async {
    return await commentApiProvider.updateComment(
        commentId: commentId,
        request: CommentRequest.forUpdate(comment: comment));
  }

  Future<void> deleteComment({required int commentId}) async {
    await commentApiProvider.deleteComment(commentId: commentId);
  }

  Future<void> reportComment(
      {required int commentId, required CommentReportRequest request}) async {
    await commentApiProvider.reportComment(
        commentId: commentId, request: request);
  }
}
