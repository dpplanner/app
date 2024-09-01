import 'club_authority_type.dart';

class ClubAuthority {
  int id;
  int clubId;
  String name;
  String description;
  List<ClubAuthorityType> authorityTypes;

  ClubAuthority(
      {required this.id,
      required this.clubId,
      required this.name,
      required this.description,
      required this.authorityTypes});

  ClubAuthority.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        clubId = json['clubId'],
        name = json['name'],
        description = json['description'],
        authorityTypes = ClubAuthorityType.fromJsonList(json['authorities']);
}
