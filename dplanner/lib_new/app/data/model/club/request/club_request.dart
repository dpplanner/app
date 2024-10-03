import '../../json_serializable.dart';
import '../club.dart';

class ClubRequest extends JsonSerializable {
  String? clubName;
  String? info;

  ClubRequest._({this.clubName, this.info});

  @override
  Map<String, dynamic> toJson() {
    return {"clubName": clubName, "info": info};
  }

  static ClubRequest forCreate(
      {required String clubName, required String info}) {
    return ClubRequest._(clubName: clubName, info: info);
  }

  static ClubRequest forUpdate({required Club club}) {
    return ClubRequest._(info: club.info);
  }
}
