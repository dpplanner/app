import '../../json_serializable.dart';

class FcmTokenRefreshRequest extends JsonSerializable {
  String fcmToken;

  FcmTokenRefreshRequest({required this.fcmToken});

  @override
  Map<String, dynamic> toJson() {
    return {'refreshFcmToken': fcmToken};
  }
}