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

  Future<Comment> createComment({required Comment comment}) async {
    return await commentApiProvider.createComment(
        request: CommentRequest.forCreate(comment: comment));
  }

  Future<Comment> updateComment(
      {required int commentId, required Comment comment}) async {
    return await commentApiProvider.updateComment(
        commentId: commentId,
        request: CommentRequest.forUpdate(comment: comment));
  }

  void deleteComment({required int commentId}) async {
    return commentApiProvider.deleteComment(commentId: commentId);
  }

  void reportComment(
      {required int commentId, required CommentReportRequest request}) async {
    return commentApiProvider.reportComment(
        commentId: commentId, request: request);
  }
}
