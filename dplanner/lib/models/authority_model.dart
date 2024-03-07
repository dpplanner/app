class AuthorityModel {
  String name, description, authorities;

  AuthorityModel(
      {required this.name,
      required this.description,
      required this.authorities});

  AuthorityModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        authorities = json['authorities'];
}
