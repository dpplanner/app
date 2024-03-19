class LockModel {
  int id, resourceId;
  String message, startDateTime, endDateTime;

  LockModel({
    required this.id,
    required this.resourceId,
    required this.message,
    required this.startDateTime,
    required this.endDateTime,
  });

  LockModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        resourceId = json['resourceId'],
        message = json['message'],
        startDateTime = json['startDateTime'],
        endDateTime = json['endDateTime'];
}
