import '../../json_serializable.dart';
import '../club_member_role_type.dart';

class ClubMemberRoleUpdateRequest extends JsonSerializable {
  ClubMemberRoleType role;
  int? clubManagerId;

  ClubMemberRoleUpdateRequest(
      {required this.role, required this.clubManagerId});

  @override
  Map<String, dynamic> toJson() {
    return {"role": role.name, "clubAuthorityId": clubManagerId};
  }
}
