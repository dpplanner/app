class ResourceModel {
  bool sharing;
  int resourceId;
  String title, usage, startDateTime, endDateTime;
  List<dynamic> reservationInvitees;

  ResourceModel({
    required this.resourceId,
    required this.title,
    required this.usage,
    required this.sharing,
    required this.startDateTime,
    required this.endDateTime,
    required this.reservationInvitees,
  });

  ResourceModel.fromJson(Map<String, dynamic> json)
      : resourceId = json['resourceId'],
        title = json['title'],
        usage = json['usage'],
        sharing = json['sharing'],
        startDateTime = json['startDateTime'],
        endDateTime = json['endDateTime'],
        reservationInvitees = json['reservationInvitees'];
}
