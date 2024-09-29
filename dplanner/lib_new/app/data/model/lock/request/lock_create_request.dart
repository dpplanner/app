import '../../json_serializable.dart';
import '../lock.dart';

class LockRequest extends JsonSerializable {
  int? id;
  int? resourceId;
  String? message;
  DateTime? startDateTime;
  DateTime? endDateTime;

  LockRequest._(
      {this.id,
      this.resourceId,
      this.message,
      this.startDateTime,
      this.endDateTime});

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "resourceId": resourceId,
      "message": message,
      "startDateTime": startDateTime,
      "endDateTime": endDateTime
    };
  }

  static LockRequest forCreate({required Lock lock}) {
    return LockRequest._(
        resourceId: lock.resourceId,
        message: lock.message,
        startDateTime: lock.startDateTime,
        endDateTime: lock.endDateTime);
  }

  static LockRequest forUpdate({required Lock lock}) {
    return LockRequest._(
        id: lock.id,
        resourceId: lock.resourceId,
        message: lock.message,
        startDateTime: lock.startDateTime,
        endDateTime: lock.endDateTime);
  }
}
