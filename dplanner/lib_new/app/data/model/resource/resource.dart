import '../json_serializable.dart';
import 'resource_type.dart';

class Resource extends JsonSerializable {
  int id;
  int clubId;
  String name;
  String info;
  bool returnMessageRequired;
  ResourceType resourceType;
  String notice;
  int? bookableSpan;

  Resource(
      {required this.id,
      required this.clubId,
      required this.name,
      required this.info,
      required this.returnMessageRequired,
      required this.resourceType,
      required this.notice,
      required this.bookableSpan});

  Resource.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        info = json['info'],
        returnMessageRequired = json['returnMessageRequired'],
        resourceType = ResourceType.fromString(json['resourceType']),
        notice = json['notice'],
        clubId = json['clubId'],
        bookableSpan = json['bookableSpan'];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Resource && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "clubId": clubId,
      "name": name,
      "info": info,
      "returnMessageRequired": returnMessageRequired,
      "resourceType": resourceType,
      "notice": notice,
      "bookableSpan": bookableSpan
    };
  }
}
