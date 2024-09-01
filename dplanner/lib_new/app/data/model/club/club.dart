class Club {
  int id;
  String clubName;
  String info;
  int? memberCount;
  bool? isConfirmed;
  String? url;

  Club({
    required this.id,
    required this.clubName,
    required this.info,
    this.memberCount,
    this.isConfirmed,
    this.url,
  });

  Club.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        clubName = json['clubName'],
        info = json['info'],
        memberCount = json['memberCount'],
        isConfirmed = json['isConfirmed'],
        url = json['url'];
}
