import 'like_status_type.dart';

class PostLike {
  final int id;
  final int postId;
  final int clubMemberId;
  final LikeStatusType likeStatus;

  PostLike({
    required this.id,
    required this.postId,
    required this.clubMemberId,
    required this.likeStatus
  });

  PostLike.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        postId = json['postId'],
        clubMemberId = json['clubMemberId'],
        likeStatus = LikeStatusType.fromString(json['likeStatus']);
}
