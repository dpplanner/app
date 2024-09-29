import '../../json_serializable.dart';
import '../club_authority_type.dart';
import '../club_manager.dart';

class ClubManagerRequest extends JsonSerializable {
  int? id;
  int? clubId;
  String? name;
  String? description;
  List<ClubAuthorityType>? authorityTypes;

  ClubManagerRequest._(
      {this.id, this.clubId, this.name, this.description, this.authorityTypes});

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "clubId": clubId,
      "name": name,
      "description": description,
      "authorityTypes":
          authorityTypes!.map((authority) => authority.name).toList()
    };
  }

  static ClubManagerRequest forCreate({required ClubManager clubManager}) {
    return ClubManagerRequest._(
        clubId: clubManager.clubId,
        name: clubManager.name,
        description: clubManager.description,
        authorityTypes: clubManager.authorityTypes);
  }

  static ClubManagerRequest forUpdate({required ClubManager clubManager}) {
    return ClubManagerRequest._(
        id: clubManager.id,
        clubId: clubManager.clubId,
        name: clubManager.name,
        description: clubManager.description,
        authorityTypes: clubManager.authorityTypes);
  }

  static ClubManagerRequest forDelete({required ClubManager clubManager}) {
    return ClubManagerRequest._(id: clubManager.id);
  }
}
