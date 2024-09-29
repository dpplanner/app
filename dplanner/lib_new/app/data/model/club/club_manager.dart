import 'club_authority_type.dart';

class ClubManager {
  int id;
  int clubId;
  String name;
  String description;
  List<ClubAuthorityType> authorityTypes;

  ClubManager(
      {required this.id,
      required this.clubId,
      required this.name,
      required this.description,
      required this.authorityTypes});

  ClubManager.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        clubId = json['clubId'],
        name = json['name'],
        description = json['description'],
        authorityTypes = ClubAuthorityType.fromJsonList(json['authorities']);
}
