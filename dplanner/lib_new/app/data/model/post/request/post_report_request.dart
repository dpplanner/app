import '../../json_serializable.dart';

class PostReportRequest extends JsonSerializable {
  int postId;
  int clubMemberId;
  String reportMessage;

  PostReportRequest(
      {required this.postId,
      required this.clubMemberId,
      required this.reportMessage});

  @override
  Map<String, dynamic> toJson() {
    return {
      "postId": postId,
      "clubMemberId": clubMemberId,
      "reportMessage": reportMessage
    };
  }
}
