class Post {
  final int id;
  final String? title; //TODO: 예시 데이터 다 갈면..
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
    required this.clubMemberId,
    required this.clubId,
    required this.clubMemberName,
    this.profileUrl,
    required this.clubRole,
    required this.likeCount,
    required this.commentCount,
    required this.likeStatus,
    required this.attachmentsUrl,
    required this.createdTime,
    this.lastModifiedTime,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    String? profileUrl = json['profileUrl'];
    if (profileUrl != null && profileUrl.startsWith("file:///")) {
      profileUrl = profileUrl.replaceFirst("file:///", "");
    }
    if (profileUrl != null && !profileUrl.startsWith("https://")) {
      profileUrl = "https://" + profileUrl;
    }

    return Post(
      id: json['id'],
      title: json['title'] != null ? json['title'] : null,
      content: json['content'],
      isFixed: json['isFixed'],
      clubId: json['clubId'],
      clubMemberId: json['clubMemberId'] as int,
      clubMemberName: json['clubMemberName'],
      profileUrl: profileUrl,
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
