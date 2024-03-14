class AlertMessageModel {
  final int id;
  final String content;
  final String title;
  final String redirectUrl;
  final bool isRead;

  AlertMessageModel({
    required this.id,
    required this.content,
    required this.title,
    required this.redirectUrl,
    required this.isRead,
  });

  factory AlertMessageModel.fromJson(Map<String, dynamic> json) {
    return AlertMessageModel(
      id: json['id'],
      content: json['content'],
      title: json['title'],
      redirectUrl: json['redirectUrl'],
      isRead: json['isRead'],
    );
  }
}
