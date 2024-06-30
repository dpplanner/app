class AlertMessageModel {
  final int id;
  final AlertMessageType type;
  final String content;
  final String title;
  final String redirectUrl;
  final bool isRead;
  final AlertMessageInfoType infoType;
  final String? info;

  AlertMessageModel({
    required this.id,
    required this.type,
    required this.content,
    required this.title,
    required this.redirectUrl,
    required this.isRead,
    required this.infoType,
    required this.info
  });

  factory AlertMessageModel.fromJson(Map<String, dynamic> json) {
    return AlertMessageModel(
      id: json['id'],
      type: AlertMessageType.fromString(json['type']),
      content: json['content'],
      title: json['title'],
      redirectUrl: json['redirectUrl'],
      isRead: json['isRead'],
      infoType: AlertMessageInfoType.fromString(json['infoType']),
      info: json['info']
    );
  }
}

enum AlertMessageType {
  REQUEST, NOTICE, REPORT, ACCEPT, REJECT, INFO;

  static AlertMessageType fromString(String? type) {
    switch(type) {
      case 'REQUEST':
        return AlertMessageType.REQUEST;
      case 'NOTICE':
        return AlertMessageType.NOTICE;
      case 'REPORT':
        return AlertMessageType.REPORT;
      case 'ACCEPT':
        return AlertMessageType.ACCEPT;
      case 'REJECT':
        return AlertMessageType.REJECT;
      case 'INFO':
        return AlertMessageType.INFO;
      default:
        return AlertMessageType.INFO;
    }
  }

  String getLowerCase() {
    return name.toLowerCase();
  }
}

enum AlertMessageInfoType {
  MEMBER, POST, RESERVATION, RETURN, NOTHING;

  static AlertMessageInfoType fromString(String? infoType) {
    switch(infoType) {
      case 'MEMBER':
        return AlertMessageInfoType.MEMBER;
      case 'POST':
        return AlertMessageInfoType.POST;
      case 'RESERVATION':
        return AlertMessageInfoType.RESERVATION;
      case 'RETURN':
        return AlertMessageInfoType.RETURN;
      default:
        return AlertMessageInfoType.NOTHING;
    }
  }
}