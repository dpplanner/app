import '../../json_serializable.dart';
import '../post.dart';

class PostRequest extends JsonSerializable {
  int? clubId;
  String? title;
  String? content;
  List<String>? attachmentUrl;

  PostRequest._({this.clubId, this.title, this.content, this.attachmentUrl});

  @override
  Map<String, dynamic> toJson() {
    return {
      "clubId": clubId,
      "title": title,
      "content": content,
      "attachmentUrl": attachmentUrl
    };
  }

  static PostRequest forCreate({required Post post}) {
    return PostRequest._(
        clubId: post.clubId,
        title: post.title,
        content: post.content);
  }

  static PostRequest forUpdate({required Post post}) {
    return PostRequest._(
        title: post.title,
        content: post.content,
        attachmentUrl: post.attachmentsUrl);
  }
}
