class ClubMemberModel {
  bool isConfirmed;
  int id;
  String name, role;
  String? info, url;

  ClubMemberModel({
    required this.id,
    required this.name,
    this.info,
    required this.role,
    this.url,
    required this.isConfirmed,
  });

  ClubMemberModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        info = json['info'],
        role = json['role'],
        url = json['url'],
        isConfirmed = json['isConfirmed'];
}
