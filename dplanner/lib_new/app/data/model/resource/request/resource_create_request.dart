import '../../json_serializable.dart';
import '../resource_type.dart';

class ResourceCreateRequest extends JsonSerializable {
  int clubId;
  String name;
  String info;
  bool returnMessageRequired;
  ResourceType resourceType;
  String notice;
  int? bookableSpan;

  ResourceCreateRequest(
      {required this.clubId,
      required this.name,
      required this.info,
      required this.returnMessageRequired,
      required this.resourceType,
      required this.notice,
      required this.bookableSpan});

  @override
  Map<String, dynamic> toJson() {
    return {
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
