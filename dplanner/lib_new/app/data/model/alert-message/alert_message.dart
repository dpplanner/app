import 'alert_message_info_type.dart';
import 'alert_message_type.dart';

class AlertMessage {
  final int id;
  final AlertMessageType type;
  final String content;
  final String title;
  final String redirectUrl;
  final bool isRead;
  final AlertMessageInfoType infoType;
  final String? info;

  AlertMessage({required this.id,
    required this.type,
    required this.content,
    required this.title,
    required this.redirectUrl,
    required this.isRead,
    required this.infoType,
    required this.info});

  AlertMessage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = AlertMessageType.fromString(json['type']),
        content = json['content'],
        title = json['title'],
        redirectUrl = json['redirectUrl'],
        isRead = json['isRead'],
        infoType = AlertMessageInfoType.fromString(json['infoType']),
        info = json['info'];
}
