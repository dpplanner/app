class Comment {
  final int id;
  final int? parentId;
  final int postId;
  final int clubMemberId;
  final String clubMemberName;
  final String? profileUrl;
  final int likeCount;
  final String content;
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
    this.profileUrl,
    required this.likeCount,
    required this.content,
    required this.isDeleted,
    required this.likeStatus,
    required this.children,
    required this.createdTime,
    this.lastModifiedTime,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    String? profileUrl = json['profileUrl'];
    if (profileUrl != null && profileUrl.startsWith("file:///")) {
      profileUrl = profileUrl.replaceFirst("file:///", "");
    }
    if (profileUrl != null && !profileUrl.startsWith("https://")) {
      profileUrl = "https://" + profileUrl;
    }
    return Comment(
      id: json['id'] as int,
      parentId: json['parentId'] as int?,
      postId: json['postId'] as int,
      clubMemberId: json['clubMemberId'] as int,
      clubMemberName: json['clubMemberName'] as String,
      profileUrl: profileUrl,
      likeCount: json['likeCount'] as int,
      content: json['content'] as String,
      isDeleted: json['isDeleted'] as bool,
      likeStatus: json['likeStatus'] as bool,
      children: (json['children'] as List<dynamic>)
          .map((childJson) =>
              Comment.fromJson(childJson as Map<String, dynamic>))
          .toList(),
      createdTime: DateTime.parse(json['createdTime'] as String),
      lastModifiedTime: json['lastModifiedTime'] != null
          ? DateTime.parse(json['lastModifiedTime'] as String)
          : null,
    );
  }
}
