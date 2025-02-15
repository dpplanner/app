class ClubJoinValidator {
  static const MAX_CLUB_MEMBER_NAME_LENGTH = 10;
  static const MAX_CLUB_MEMBER_INFO_LENGTH = 200;
  static const CLUB_MEMBER_NAME_FORMAT = '[a-zA-Z가-힣,.!?0-9]';

  String? validateClubMemberName(String? value) {
    if (value == null || value.isEmpty) {
      return '이름을 작성해주세요';
    } else if (value.length > MAX_CLUB_MEMBER_NAME_LENGTH) {
      return "이름은 $MAX_CLUB_MEMBER_NAME_LENGTH 자 이내로 작성해주세요";
    } else if (!RegExp(CLUB_MEMBER_NAME_FORMAT).hasMatch(value)) {
      return '이름은 영어,한글,숫자,특수문자(,.!?)만 쓸 수 있어요';
    }
    return null;
  }

  String? validateClubMemberInfo(String? value) {
    if (value != null && value.length > MAX_CLUB_MEMBER_INFO_LENGTH) {
      return "소개글은 $MAX_CLUB_MEMBER_INFO_LENGTH 자 이내로 작성해주세요";
    }
    return null;
  }
}