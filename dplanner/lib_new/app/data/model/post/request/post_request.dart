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

  static PostRequest forCreate(
      {required int clubId, required String title, required String content}) {
    return PostRequest._(clubId: clubId, title: title, content: content);
  }

  static PostRequest forUpdate({required Post post}) {
    return PostRequest._(
        title: post.title,
        content: post.content,
        attachmentUrl: post.attachmentsUrl);
  }
}
