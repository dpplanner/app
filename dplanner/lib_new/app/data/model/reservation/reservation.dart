import 'reservation_invitee.dart';
import 'reservation_status_type.dart';

class Reservation {
  int reservationId;

  int clubMemberId;
  String clubMemberName;

  int resourceId;
  String resourceName;

  String title;
  String usage;
  DateTime startDateTime;
  DateTime endDateTime;
  String color;
  bool sharing;
  List<ReservationInvitee> invitees;

  ReservationStatusType status;
  String? rejectMessage;
  bool returned;
  DateTime createDate;
  DateTime? lastModifiedDate;

  List<String> attachmentsUrl;
  String? returnMessage;

  bool isDummy;

  Reservation(
      {required this.reservationId,
      required this.clubMemberId,
      required this.clubMemberName,
      required this.resourceId,
      required this.resourceName,
      required this.title,
      required this.usage,
      required this.startDateTime,
      required this.endDateTime,
      required this.color,
      required this.sharing,
      required this.invitees,
      required this.status,
      required this.rejectMessage,
      required this.returned,
      required this.createDate,
      required this.lastModifiedDate,
      required this.attachmentsUrl,
      this.isDummy = false});

  Reservation.fromJson(Map<String, dynamic> json)
      : reservationId = json['reservationId'],
        clubMemberId = json['clubMemberId'],
        clubMemberName = json['clubMemberName'],
        resourceId = json['resourceId'],
        resourceName = json['resourceName'],
        title = json['title'],
        color = json['color'],
        usage = json['usage'],
        sharing = json['sharing'],
        status = json['status'],
        returnMessage = json['returnMessage'],
        attachmentsUrl = json['attachmentsUrl'],
        invitees = ReservationInvitee.fromJsonList(json['invitees']),
        startDateTime = DateTime.parse(json['startDateTime']),
        endDateTime = DateTime.parse(json['endDateTime']),
        createDate = DateTime.parse(json['createDate']),
        lastModifiedDate = DateTime.tryParse(json['lastModifiedDate']),
        returned = json['returned'],
        rejectMessage = json['rejectMessage'],
        isDummy = false;

  static Reservation ofDummy(String startDateTime, String endDateTime) {
    return Reservation(
        reservationId: -1,
        clubMemberId: -1,
        clubMemberName: "SYSTEM",
        resourceId: -1,
        resourceName: "",
        title: "",
        color: "",
        usage: "",
        sharing: false,
        status: ReservationStatusType.REQUEST,
        attachmentsUrl: [],
        invitees: [],
        startDateTime: DateTime.parse(startDateTime),
        endDateTime: DateTime.parse(endDateTime),
        createDate: DateTime.now(),
        lastModifiedDate: DateTime.now(),
        returned: false,
        rejectMessage: null,
        isDummy: true);
  }
}
