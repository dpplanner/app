import '../../../../config/constants/app_colors.dart';
import 'reservation_invitee.dart';
import 'reservation_status_type.dart';

class Reservation {
  final int id;

  int clubMemberId;
  String clubMemberName;

  final int resourceId;
  final String resourceName;

  DateTime startDateTime;
  DateTime endDateTime;
  String title;
  String usage;
  String color;
  bool sharing;
  List<ReservationInvitee> invitees;

  final ReservationStatusType status;
  String? rejectMessage;
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

  bool isRequest() => status == ReservationStatusType.REQUEST;

  bool isConfirmed() => status == ReservationStatusType.CONFIRMED;

  bool isRejected() => status == ReservationStatusType.REJECTED;

  bool isOwner(int? id) => clubMemberId == id;

  bool isStarted() => DateTime.now().isAfter(startDateTime);

  bool hasTitle() => title.isNotEmpty;

  bool hasUsage() => usage.isNotEmpty;

  bool hasInvitees() => invitees.isNotEmpty;

  bool hasReturnMessage() => returnMessage?.isNotEmpty == true;

  bool hasReturnImages() => attachmentsUrl.isNotEmpty;

  Reservation.fromJson(Map<String, dynamic> json)
      : id = json['reservationId'],
        clubMemberId = json['clubMemberId'],
        clubMemberName = json['clubMemberName'],
        resourceId = json['resourceId'],
        resourceName = json['resourceName'],
        title = json['title'] ?? "",
        color = json['color'],
        usage = json['usage'] ?? "",
        sharing = json['sharing'],
        status = ReservationStatusType.fromString(json['status']),
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

  Reservation copy() {
    return Reservation(
      id: id,
      clubMemberId: clubMemberId,
      clubMemberName: clubMemberName,
      resourceId: resourceId,
      resourceName: resourceName,
      title: title,
      usage: usage,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      color: color,
      sharing: sharing,
      invitees: invitees.map((invitee) => invitee.copy()).toList(),
      status: status,
      rejectMessage: rejectMessage,
      returned: returned,
      createDate: createDate,
      lastModifiedDate: lastModifiedDate,
      attachmentsUrl: List<String>.from(attachmentsUrl),
      returnMessage: returnMessage,
      isDummy: isDummy,
    );
  }

  static Reservation ofDummy({String? startDateTime, String? endDateTime}) {
    return Reservation(
      id: -1,
      clubMemberId: -1,
      clubMemberName: "SYSTEM",
      resourceId: -1,
      resourceName: "",
      title: "",
      color: ReservationColors.getColorHex(ReservationColors.reservationColors.first),
      usage: "",
      sharing: false,
      status: ReservationStatusType.REQUEST,
      attachmentsUrl: [],
      invitees: [],
      startDateTime: DateTime.parse(startDateTime ?? "20250101T000000"),
      endDateTime: DateTime.parse(endDateTime ?? "20250101T010000"),
      createDate: DateTime.now(),
      lastModifiedDate: DateTime.now(),
      returned: false,
      rejectMessage: null,
      returnMessage: null,
      isDummy: true,
    );
  }
}
