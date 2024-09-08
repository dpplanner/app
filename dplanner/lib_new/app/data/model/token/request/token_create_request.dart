import '../../json_serializable.dart';

class TokenIssueRequest extends JsonSerializable {
  String email;
  String name;

  TokenIssueRequest({
    required this.email,
    required this.name});

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name
    };
  }
}