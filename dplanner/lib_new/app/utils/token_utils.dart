import 'package:jwt_decoder/jwt_decoder.dart';

class TokenUtils {
  static const String _memberIdKey = "sub";
  static const String _recentClubIdKey = "recent_club_id";
  static const String _clubMemberIdKey = "club_member_id";

  static int getMemberId({required String accessToken}) {
    return _parseInt(JwtDecoder.decode(accessToken)[_memberIdKey]);
  }

  static int getRecentClubId({required String accessToken}) {
    return _parseInt(JwtDecoder.decode(accessToken)[_recentClubIdKey]);
  }

  static int getRecentClubMemberId({required String accessToken}) {
    return _parseInt(JwtDecoder.decode(accessToken)[_clubMemberIdKey]);
  }

  static int _parseInt(dynamic id) {
    return id is int ? id : int.tryParse(id)!;
  }
}
