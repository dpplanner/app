import 'package:jwt_decoder/jwt_decoder.dart';

class TokenUtils {
  static const String _memberIdKey = "sub";

  static int getMemberId({required String accessToken}) {
    return JwtDecoder.decode(accessToken)[_memberIdKey];
  }
}