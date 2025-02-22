class ClubFindValidator {

  String? validateClubInviteCode(String? value) {
    if (value == null || value.isEmpty) {
      return '클럽 초대코드를 정확히 입력해주세요';
    }
    return null;
  }
}