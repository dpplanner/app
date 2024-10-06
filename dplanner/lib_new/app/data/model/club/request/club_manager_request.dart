import '../../json_serializable.dart';
import '../club_authority_type.dart';
import '../club_manager.dart';

class ClubManagerRequest extends JsonSerializable {
  int? id;
  int? clubId;
  String? name;
  String? description;
  List<ClubAuthorityType>? authorities;

  ClubManagerRequest._(
      {this.id, this.clubId, this.name, this.description, this.authorities});

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "clubId": clubId,
      "name": name,
      "description": description,
      "authorities":
      authorities?.map((authority) => authority.name).toList()
    };
  }

  static ClubManagerRequest forCreate(
      {required int clubId,
      required String name,
      required List<ClubAuthorityType> authorityTypes,
      required String? description}) {
    return ClubManagerRequest._(
        clubId: clubId,
        name: name,
        authorities: authorityTypes,
        description: description);
  }

  static ClubManagerRequest forUpdate({required ClubManager clubManager}) {
    return ClubManagerRequest._(
        id: clubManager.id,
        clubId: clubManager.clubId,
        name: clubManager.name,
        description: clubManager.description,
        authorities: clubManager.authorityTypes);
  }

  static ClubManagerRequest forDelete({required ClubManager clubManager}) {
    return ClubManagerRequest._(id: clubManager.id);
  }
}
