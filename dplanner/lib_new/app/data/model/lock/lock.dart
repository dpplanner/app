class Lock {
  int id;
  int resourceId;
  String message;
  DateTime startDateTime;
  DateTime endDateTime;

  Lock({
    required this.id,
    required this.resourceId,
    required this.message,
    required this.startDateTime,
    required this.endDateTime,
  });

  Lock.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        resourceId = json['resourceId'],
        message = json['message'],
        startDateTime = DateTime.parse(json['startDateTime']),
        endDateTime = DateTime.parse(json['endDateTime']);
}
