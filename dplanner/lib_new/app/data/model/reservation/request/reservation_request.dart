import '../../../../utils/datetime_utils.dart';
import '../../json_serializable.dart';
import '../reservation.dart';

class ReservationRequest extends JsonSerializable {
  int? reservationId;
  int? reservationOwnerId;
  int? resourceId;
  String? title;
  String? color;
  String? usage;
  bool? sharing;
  DateTime? startDateTime;
  DateTime? endDateTime;
  List<int>? reservationInvitees;
  String? rejectMessage;
  String? returnMessage;

  ReservationRequest._(
      {this.reservationId,
      this.reservationOwnerId,
      this.resourceId,
      this.title,
      this.color,
      this.usage,
      this.sharing,
      this.startDateTime,
      this.endDateTime,
      this.reservationInvitees,
      this.rejectMessage,
      this.returnMessage});

  @override
  Map<String, dynamic> toJson() {
    return {
      "reservationId": reservationId,
      "reservationOwnerId": reservationOwnerId,
      "resourceId": resourceId,
      "title": title,
      "color": color,
      "usage": usage,
      "sharing": sharing,
      "startDateTime": startDateTime != null
          ? DateTimeUtils.toFormattedString(startDateTime!)
          : null,
      "endDateTime": endDateTime != null
          ? DateTimeUtils.toFormattedString(endDateTime!)
          : null,
      "reservationInvitees": reservationInvitees,
      "rejectMessage": rejectMessage,
      "returnMessage": returnMessage
    };
  }

  static ReservationRequest forCreate(
      {required int reservationOwnerId,
      required int resourceId,
      required DateTime startDateTime,
      required DateTime endDateTime,
      required String color,
      required String? title,
      required String? usage,
      required List<int>? reservationInvitees,
      required bool sharing}) {
    return ReservationRequest._(
        reservationOwnerId: reservationOwnerId,
        resourceId: resourceId,
        title: title,
        color: color,
        usage: usage,
        sharing: sharing,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        reservationInvitees: reservationInvitees ?? []);
  }

  static ReservationRequest forUpdate({required Reservation reservation}) {
    return ReservationRequest._(
        resourceId: reservation.resourceId,
        title: reservation.title,
        color: reservation.color,
        usage: reservation.usage,
        sharing: reservation.sharing,
        startDateTime: reservation.startDateTime,
        endDateTime: reservation.endDateTime,
        reservationInvitees:
            reservation.invitees.map((invitee) => invitee.id).toList());
  }

  static ReservationRequest forUpdateOwner({required int reservationOwnerId}) {
    return ReservationRequest._(reservationOwnerId: reservationOwnerId);
  }

  static ReservationRequest forCancel({required Reservation reservation}) {
    return ReservationRequest._(reservationId: reservation.id);
  }

  static ReservationRequest forDelete({required Reservation reservation}) {
    return ReservationRequest._(reservationId: reservation.id);
  }

  static ReservationRequest forConfirm({required Reservation reservation}) {
    return ReservationRequest._(reservationId: reservation.id);
  }

  static ReservationRequest forReject({required Reservation reservation}) {
    return ReservationRequest._(
        reservationId: reservation.id,
        rejectMessage: reservation.rejectMessage);
  }

  static ReservationRequest forReturn(
      {required Reservation reservation, String? returnMessage}) {
    return ReservationRequest._(
        reservationId: reservation.id,
        returnMessage: reservation.returnMessage);
  }
}
