class ReservationModel {
  bool sharing, returned;
  int reservationId, clubMemberId, resourceId;
  String clubMemberName,
      resourceName,
      title,
      usage,
      status,
      startDateTime,
      endDateTime,
      createDate,
      lastModifiedDate;
  List<dynamic> attachmentsUrl;
  List<Map<String, dynamic>> invitees;
  String? returnMessage, rejectMessage;

  ReservationModel(
      {required this.reservationId,
      required this.clubMemberId,
      required this.clubMemberName,
      required this.resourceId,
      required this.resourceName,
      required this.title,
      required this.usage,
      required this.sharing,
      required this.status,
      required this.attachmentsUrl,
      required this.invitees,
      required this.startDateTime,
      required this.endDateTime,
      required this.createDate,
      required this.lastModifiedDate,
      required this.returned,
      required this.rejectMessage});

  ReservationModel.fromJson(Map<String, dynamic> json)
      : reservationId = json['reservationId'],
        clubMemberId = json['clubMemberId'],
        clubMemberName = json['clubMemberName'],
        resourceId = json['resourceId'],
        resourceName = json['resourceName'],
        title = json['title'],
        usage = json['usage'],
        sharing = json['sharing'],
        status = json['status'],
        returnMessage = json['returnMessage'],
        attachmentsUrl = json['attachmentsUrl'],
        invitees = List<Map<String, dynamic>>.from(
            json['invitees'].map((i) => Map<String, dynamic>.from(i))),
        startDateTime = json['startDateTime'],
        endDateTime = json['endDateTime'],
        createDate = json['createDate'],
        lastModifiedDate = json['lastModifiedDate'],
        returned = json['returned'],
        rejectMessage = json['rejectMessage'];
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
