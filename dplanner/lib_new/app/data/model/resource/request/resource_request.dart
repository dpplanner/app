import '../../json_serializable.dart';
import '../resource.dart';
import '../resource_type.dart';

class ResourceRequest extends JsonSerializable {
  int? id;
  int? clubId;
  String? name;
  String? info;
  bool? returnMessageRequired;
  ResourceType? resourceType;
  String? notice;
  int? bookableSpan;

  ResourceRequest._(
      {this.id,
      this.clubId,
      this.name,
      this.info,
      this.returnMessageRequired,
      this.resourceType,
      this.notice,
      this.bookableSpan});

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "clubId": clubId,
      "name": name,
      "info": info,
      "returnMessageRequired": returnMessageRequired,
      "resourceType": resourceType?.name,
      "notice": notice,
      "bookableSpan": bookableSpan
    };
  }

  static ResourceRequest forCreate(
      {required int clubId,
      required String name,
      required ResourceType resourceType,
      required String info,
      required int bookableSpan,
      required String? notice,
      required bool returnMessageRequired}) {
    return ResourceRequest._(
        clubId: clubId,
        name: name,
        info: info,
        returnMessageRequired: returnMessageRequired,
        resourceType: resourceType,
        notice: notice,
        bookableSpan: bookableSpan);
  }

  static ResourceRequest forUpdate({required Resource resource}) {
    return ResourceRequest._(
        id: resource.id,
        clubId: resource.clubId,
        name: resource.name,
        info: resource.info,
        returnMessageRequired: resource.returnMessageRequired,
        resourceType: resource.resourceType,
        notice: resource.notice,
        bookableSpan: resource.bookableSpan);
  }
}
