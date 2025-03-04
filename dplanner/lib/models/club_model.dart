class ClubModel {
  bool? isConfirmed;
  int id;
  int? memberCount;
  String clubName, info;
  String? url;

  ClubModel({
    required this.id,
    required this.clubName,
    required this.info,
    this.memberCount,
    this.isConfirmed,
    this.url,
  });

  ClubModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        clubName = json['clubName'],
        info = json['info'] ?? "",
        memberCount = json['memberCount'],
        isConfirmed = json['isConfirmed'],
        url = json['url'];
}
