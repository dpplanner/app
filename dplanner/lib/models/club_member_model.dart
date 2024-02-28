class ClubMemberModel {
  bool confirmed;
  int id;
  String name, info, role;

  ClubMemberModel({
    required this.id,
    required this.name,
    required this.info,
    required this.role,
    required this.confirmed,
  });

  ClubMemberModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        info = json['info'],
        role = json['role'],
        confirmed = json['confirmed'];
}
