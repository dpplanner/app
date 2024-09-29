enum ClubMemberRoleType {
  ADMIN,
  MANAGER,
  USER,
  NONE;

  static ClubMemberRoleType fromString(String? type) {
    switch (type) {
      case 'ADMIN':
        return ADMIN;
      case 'MANAGER':
        return MANAGER;
      case 'USER':
        return USER;
      case 'NONE':
        return NONE;
      default:
        return NONE;
    }
  }
}
