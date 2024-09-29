import 'club_authority_type.dart';
import 'club_member_role_type.dart';

class ClubMember {
  int id;
  String name;
  ClubMemberRoleType role;
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
        role = ClubMemberRoleType.fromString(json['role']),
        isConfirmed = json['isConfirmed'],
        info = json['info'],
        url = json['url'],
        clubAuthorityId = json['clubAuthorityId'],
        clubAuthorityName = json['clubAuthorityName'],
        clubAuthorityTypes =
            ClubAuthorityType.fromJsonList(json['clubAuthorityTypes']);
}
