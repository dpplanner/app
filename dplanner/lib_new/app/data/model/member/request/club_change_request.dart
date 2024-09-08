import '../../json_serializable.dart';

class ClubChangeRequest extends JsonSerializable {
  int clubId;

  ClubChangeRequest({required this.clubId});

  @override
  Map<String, dynamic> toJson() {
    return {'clubId': clubId};
  }
}
