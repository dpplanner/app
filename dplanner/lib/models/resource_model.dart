class ResourceModel {
  bool returnMessageRequired;
  int id, clubId;
  String name, info, resourceType, notice;
  int? bookableSpan;

  ResourceModel(
      {required this.id,
      required this.name,
      required this.info,
      required this.returnMessageRequired,
      required this.resourceType,
      required this.notice,
      required this.clubId,
      required this.bookableSpan});

  ResourceModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        info = json['info'],
        returnMessageRequired = json['returnMessageRequired'],
        resourceType = json['resourceType'],
        notice = json['notice'],
        clubId = json['clubId'],
        bookableSpan = json['bookableSpan'];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourceModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
