import '../../model/comment/comment.dart';
import '../../model/comment/request/comment_report_request.dart';
import '../../model/comment/request/comment_request.dart';
import '../../model/common_response.dart';
import 'base_api_provider.dart';

class CommentApiProvider extends BaseApiProvider {
  Future<List<Comment>> getComments({required int postId}) async {
    var response = await get("/posts/$postId/comments") as CommonResponse;
    var jsonList = response.body!.data as List<dynamic>;

    return jsonList.map((message) => Comment.fromJson(message)).toList();
  }

  Future<Comment> createComment({required CommentRequest request}) async {
    var response = await post("/comments", request.toJson()) as CommonResponse;
    return Comment.fromJson(response.body!.data!);
  }

  Future<Comment> updateComment(
      {required int commentId, required CommentRequest request}) async {
    var response =
        await put("/comments/$commentId", request.toJson()) as CommonResponse;
    return Comment.fromJson(response.body!.data!);
  }

  Future<void> deleteComment({required int commentId}) async {
    await delete("/comments/$commentId");
  }

  Future<void> reportComment(
      {required int commentId, required CommentReportRequest request}) async {
    await post("/comments/$commentId/report", request.toJson())
        as CommonResponse;
  }
}
