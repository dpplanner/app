class ClubMemberModel {
  bool isConfirmed;
  int id;
  int? clubAuthorityId;
  String name, role;
  String? info, url, clubAuthorityName;
  List<dynamic>? clubAuthorityTypes;

  ClubMemberModel(
      {required this.id,
      required this.name,
      this.info,
      required this.role,
      this.url,
      required this.isConfirmed,
      this.clubAuthorityId,
      this.clubAuthorityName,
      this.clubAuthorityTypes});

  ClubMemberModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        info = json['info'],
        role = json['role'],
        url = json['url'],
        isConfirmed = json['isConfirmed'],
        clubAuthorityId = json['clubAuthorityId'],
        clubAuthorityName = json['clubAuthorityName'],
        clubAuthorityTypes = json['clubAuthorityTypes'];
}
