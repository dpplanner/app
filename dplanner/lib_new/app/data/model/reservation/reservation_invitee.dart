class ReservationInvitee {
  int id;
  String name;
  bool isDeleted;

  ReservationInvitee(
      {required this.id, required this.name, required this.isDeleted});

  ReservationInvitee.fromJson(Map<String, dynamic> json)
      : id = json['clubMemberId'],
        name = json['clubMemberName'],
        isDeleted = json['clubMemberIsDeleted'];

  static List<ReservationInvitee> fromJsonList(List<dynamic> invitees) {
    return invitees
        .map((invitee) => ReservationInvitee.fromJson(invitee))
        .toList();
  }
}
