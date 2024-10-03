import '../../json_serializable.dart';
import '../comment.dart';

class CommentRequest extends JsonSerializable {
  int? id;
  int? postId;
  int? parentId;
  String? content;

  CommentRequest._({this.id, this.postId, this.parentId, this.content});

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "postId": postId,
      "parentId": parentId,
      "content": content
    };
  }

  static CommentRequest forCreate(
      {required int postId, required int? parentId, required String content}) {
    return CommentRequest._(
        postId: postId, parentId: parentId, content: content);
  }

  static CommentRequest forUpdate({required Comment comment}) {
    return CommentRequest._(id: comment.id, content: comment.content);
  }
}
