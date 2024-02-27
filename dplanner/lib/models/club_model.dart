class ClubModel {
  final bool isConfirmed;
  final int id, memberCount;
  final String clubName, info, url;

  ClubModel({
    required this.id,
    required this.clubName,
    required this.info,
    required this.memberCount,
    required this.isConfirmed,
    required this.url,
  });

  ClubModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        clubName = json['clubName'],
        info = json['info'],
        memberCount = json['memberCount'],
        isConfirmed = json['isConfirmed'],
        url = json['url'];
}
