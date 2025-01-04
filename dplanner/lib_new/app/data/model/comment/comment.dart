import '../../../utils/url_utils.dart';

class Comment {
  final int id;
  final int? parentId;
  final int postId;
  final int clubMemberId;
  final String clubMemberName;
  final String? profileUrl;
  final int likeCount;
  String content;
  final bool isDeleted;
  final bool likeStatus;
  final List<Comment> children;
  final DateTime createdTime;
  final DateTime? lastModifiedTime;

  Comment({
    required this.id,
    this.parentId,
    required this.postId,
    required this.clubMemberId,
    required this.clubMemberName,
    required this.likeCount,
    required this.content,
    required this.isDeleted,
    required this.likeStatus,
    required this.children,
    required this.createdTime,
    this.profileUrl,
    this.lastModifiedTime,
  });

  Comment.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        parentId = json['parentId'] as int?,
        postId = json['postId'] as int,
        clubMemberId = json['clubMemberId'] as int,
        clubMemberName = json['clubMemberName'] as String,
        profileUrl = UrlUtils.toHttps(json['profileUrl']),
        likeCount = json['likeCount'] as int,
        content = json['content'] as String,
        isDeleted = json['isDeleted'] as bool,
        likeStatus = json['likeStatus'] == true,
        children = fromJsonList(json['children']),
        createdTime = DateTime.parse(json['createdTime'] as String),
        lastModifiedTime = DateTime.tryParse(json['lastModifiedTime']);

  static List<Comment> fromJsonList(List<dynamic> comments) {
    return comments.map((comment) => Comment.fromJson(comment)).toList();
  }
}
