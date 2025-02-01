class ClubCreateValidator {
  static const MAX_CLUB_NAME_LENGTH = 15;
  static const MAX_CLUB_INFO_LENGTH = 200;
  static const CLUB_NAME_FORMAT = '[a-zA-Z가-힣,.!?]';

  String? validateClubName(String? value) {
    if (value == null || value.isEmpty) {
      return '클럽 이름을 작성해주세요';
    } else if (value.length > MAX_CLUB_NAME_LENGTH) {
      return "클럽 이름은 $MAX_CLUB_NAME_LENGTH 자 이내로 작성해주세요";
    } else if (!RegExp(CLUB_NAME_FORMAT).hasMatch(value)) {
      return '클럽 이름은 영어,한글,숫자,특수문자(,.!?)만 쓸 수 있어요';
    }
    return null;
  }

  String? validateClubInfo(String? value) {
    if (value == null || value.isEmpty) {
      return '클럽 소개글을 작성해주세요';
    } else if (value.length > MAX_CLUB_INFO_LENGTH) {
      return "클럽 소개글은 $MAX_CLUB_INFO_LENGTH 자 이내로 작성해주세요";
    }
    return null;
  }
}