enum AlertMessageInfoType {
  MEMBER,
  POST,
  RESERVATION,
  RETURN,
  NOTHING;

  static AlertMessageInfoType fromString(String? infoType) {
    switch (infoType) {
      case 'MEMBER':
        return MEMBER;
      case 'POST':
        return POST;
      case 'RESERVATION':
        return RESERVATION;
      case 'RETURN':
        return RETURN;
      default:
        return NOTHING;
    }
  }
}
