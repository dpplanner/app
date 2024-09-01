import '../../../utils/url_utils.dart';

class Post {
  final int id;
  final String? title;
  final String content;
  bool isFixed;
  final int clubId;
  final int clubMemberId;
  final String clubMemberName;
  final String? profileUrl;
  final String clubRole;
  final int commentCount;
  int likeCount;
  bool likeStatus;
  final List<String> attachmentsUrl;
  final DateTime createdTime;
  final DateTime? lastModifiedTime;

  Post({
    required this.id,
    this.title,
    required this.content,
    required this.isFixed,
    required this.clubId,
    required this.clubMemberId,
    required this.clubMemberName,
    this.profileUrl,
    required this.clubRole,
    required this.commentCount,
    required this.likeCount,
    required this.likeStatus,
    required this.attachmentsUrl,
    required this.createdTime,
    this.lastModifiedTime,
  });

  Post.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        isFixed = json['isFixed'],
        clubId = json['clubId'],
        clubMemberId = json['clubMemberId'] as int,
        clubMemberName = json['clubMemberName'],
        profileUrl = UrlUtils.toHttps(json['profileUrl']),
        clubRole = json['clubRole'],
        likeCount = json['likeCount'],
        commentCount = json['commentCount'],
        likeStatus = json['likeStatus'],
        attachmentsUrl = List<String>.from(json['attachmentsUrl']),
        createdTime = DateTime.parse(json['createdTime']),
        lastModifiedTime = DateTime.tryParse(json['lastModifiedTime']);
}
