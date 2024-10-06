class ClubInviteCode {
  int clubId;
  String inviteCode;
  bool? verify;

  ClubInviteCode(
      {required this.clubId, required this.inviteCode, required this.verify});

  ClubInviteCode.fromJson(Map<String, dynamic> json)
      : clubId = json['clubId'],
        inviteCode = json['inviteCode'],
        verify = json['verify'];
}
