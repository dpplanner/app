import 'reservation_invitee.dart';
import 'reservation_status_type.dart';

class Reservation {
  final int id;

  int clubMemberId;
  String clubMemberName;

  final int resourceId;
  final String resourceName;

  final DateTime startDateTime;
  final DateTime endDateTime;
  String title;
  String usage;
  String color;
  bool sharing;
  List<ReservationInvitee> invitees;

  final ReservationStatusType status;
  final String? rejectMessage;
  final bool returned;
  final DateTime createDate;
  final DateTime? lastModifiedDate;

  final List<String> attachmentsUrl;
  String? returnMessage;

  final bool isDummy;

  Reservation(
      {required this.id,
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
      required this.returnMessage,
      this.isDummy = false});

  Reservation.fromJson(Map<String, dynamic> json)
      : id = json['reservationId'],
        clubMemberId = json['clubMemberId'],
        clubMemberName = json['clubMemberName'],
        resourceId = json['resourceId'],
        resourceName = json['resourceName'],
        title = json['title'],
        color = json['color'],
        usage = json['usage'],
        sharing = json['sharing'],
        status = ReservationStatusType.fromString(json['status']) ,
        returnMessage = json['returnMessage'],
        attachmentsUrl = List<String>.from(json['attachmentsUrl']),
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
      id: -1,
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
      returnMessage: null,
      isDummy: true,
    );
  }
}
