import '../../json_serializable.dart';
import '../club_member.dart';

class ClubMemberRequest extends JsonSerializable {
  int? id;
  String? name;
  String? info;

  ClubMemberRequest._({this.id, this.name, this.info});

  @override
  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "info": info};
  }

  static ClubMemberRequest forCreate({required ClubMember clubMember}) {
    return ClubMemberRequest._(name: clubMember.name, info: clubMember.info);
  }

  static ClubMemberRequest forUpdate({required ClubMember clubMember}) {
    return ClubMemberRequest._(
        id: clubMember.id, name: clubMember.name, info: clubMember.info);
  }

  static ClubMemberRequest forConfirm({required ClubMember clubMember}) {
    return ClubMemberRequest._(id: clubMember.id);
  }

  static ClubMemberRequest forReject({required ClubMember clubMember}) {
    return ClubMemberRequest._(id: clubMember.id);
  }
}
