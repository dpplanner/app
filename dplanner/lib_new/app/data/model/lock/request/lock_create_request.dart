import '../../json_serializable.dart';

class LockCreateRequest extends JsonSerializable {
  int resourceId;
  String message;
  DateTime startDateTime;
  DateTime endDateTime;


  LockCreateRequest({required this.resourceId,
    required this.message,
    required this.startDateTime,
    required this.endDateTime});

  @override
  Map<String, dynamic> toJson() {
    return {
      "resourceId": resourceId,
      "message": message,
      "startDateTime": startDateTime,
      "endDateTime": endDateTime
    };
  }

}