class ClubManagerModel {
  int id, clubId;
  String name, description;
  List<dynamic> authorities;

  ClubManagerModel(
      {required this.id,
      required this.clubId,
      required this.name,
      required this.description,
      required this.authorities});

  ClubManagerModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        clubId = json['clubId'],
        name = json['name'],
        description = json['description'] ?? "",
        authorities = json['authorities'];
}
