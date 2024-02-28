class Post {
  final int id;
  final String title;
  final String content;
  final bool isFixed;
  final int clubId;
  final String clubMemberName;
  final String clubRole;
  final int likeCount;
  final int commentCount;
  final bool likeStatus;
  final List<String> attachmentsUrl;
  final DateTime createdTime;
  final DateTime? lastModifiedTime;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.isFixed,
    required this.clubId,
    required this.clubMemberName,
    required this.clubRole,
    required this.likeCount,
    required this.commentCount,
    required this.likeStatus,
    required this.attachmentsUrl,
    required this.createdTime,
    this.lastModifiedTime,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      isFixed: json['isFixed'],
      clubId: json['clubId'],
      clubMemberName: json['clubMemberName'],
      clubRole: json['clubRole'],
      likeCount: json['likeCount'],
      commentCount: json['commentCount'],
      likeStatus: json['likeStatus'],
      attachmentsUrl: List<String>.from(json['attachmentsUrl']),
      createdTime: DateTime.parse(json['createdTime']),
      lastModifiedTime: json['lastModifiedTime'] != null
          ? DateTime.parse(json['lastModifiedTime'])
          : null,
    );
  }
}
