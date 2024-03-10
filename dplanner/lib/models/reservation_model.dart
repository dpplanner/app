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

// "reservationId": 25,
// "clubMemberId": 1046,
// "clubMemberName": "남진",
// "resourceId": 67,
// "resourceName": "동방",
// "title": "Reservation Title",
// "usage": "Reservation Usage",
// "sharing": true,
// "status": "CONFIRMED",
// "returnMessage": null,
// "attachmentsUrl": [],
// "invitees": [],
// "startDateTime": "2024-03-09 00:12:00",
// "endDateTime": "2024-03-09 00:14:00",
// "createDate": "2024-03-10T07:28:30.204241",
// "lastModifiedDate": "2024-03-10T07:28:30.279837",
// "returned": false
