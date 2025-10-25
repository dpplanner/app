class ReservationInvitee {
  int id;
  String name;
  bool isDeleted;
  String? profileImageUrl;

  ReservationInvitee(
      {required this.id, required this.name, required this.isDeleted, this.profileImageUrl});

  ReservationInvitee.fromJson(Map<String, dynamic> json)
      : id = json['clubMemberId'],
        name = json['clubMemberName'],
        isDeleted = json['clubMemberIsDeleted'],
        profileImageUrl = json['profileImageUrl'];

  ReservationInvitee copy() {
    return ReservationInvitee(
        id: id, name: name, profileImageUrl: profileImageUrl, isDeleted: isDeleted);
  }

  static List<ReservationInvitee> fromJsonList(List<dynamic> invitees) {
    return invitees.map((invitee) => ReservationInvitee.fromJson(invitee)).toList();
  }
}
