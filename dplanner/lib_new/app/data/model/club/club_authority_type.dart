enum ClubAuthorityType {
  MEMBER_ALL,
  SCHEDULE_ALL,
  POST_ALL,
  RESOURCE_ALL,
  RETURN_MSG_READ,
  NONE;

  static ClubAuthorityType fromString(String? type) {
    switch (type) {
      case 'MEMBER_ALL':
        return MEMBER_ALL;
      case 'SCHEDULE_ALL':
        return SCHEDULE_ALL;
      case 'POST_ALL':
        return POST_ALL;
      case 'RETURN_MSG_READ':
        return RETURN_MSG_READ;
      case 'RESOURCE_ALL':
        return RESOURCE_ALL;
      case 'NONE':
        return NONE;
      default:
        return NONE;
    }
  }

  static List<ClubAuthorityType> fromJsonList(List<dynamic>? types) {
    return types != null ? types.map((type) => fromString(type)).toList() : [];
  }
}
