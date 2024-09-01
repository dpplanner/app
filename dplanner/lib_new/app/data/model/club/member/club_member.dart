import '../authority/club_authority_type.dart';

class ClubMember {
  int id;
  String name;
  String role;
  bool isConfirmed;
  String? info;
  String? url;
  int? clubAuthorityId;
  String? clubAuthorityName;
  List<ClubAuthorityType>? clubAuthorityTypes;

  ClubMember(
      {required this.id,
      required this.name,
      required this.role,
      required this.isConfirmed,
      this.info,
      this.url,
      this.clubAuthorityId,
      this.clubAuthorityName,
      this.clubAuthorityTypes});

  ClubMember.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        role = json['role'],
        isConfirmed = json['isConfirmed'],
        info = json['info'],
        url = json['url'],
        clubAuthorityId = json['clubAuthorityId'],
        clubAuthorityName = json['clubAuthorityName'],
        clubAuthorityTypes =
            ClubAuthorityType.fromJsonList(json['clubAuthorityTypes']);
}
