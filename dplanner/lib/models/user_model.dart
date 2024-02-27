// 사용 x

class UserModel {
  final String email, name;

  UserModel({required this.email, required this.name});

  UserModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        name = json['name'];
}
