import '../../json_serializable.dart';

class CommentReportRequest extends JsonSerializable {
  int commentId;
  int clubMemberId;
  String reportMessage;

  CommentReportRequest(
      {required this.commentId,
      required this.clubMemberId,
      required this.reportMessage});

  @override
  Map<String, dynamic> toJson() {
    return {
      "commentId": commentId,
      "clubMemberId": clubMemberId,
      "reportMessage": reportMessage
    };
  }
}
