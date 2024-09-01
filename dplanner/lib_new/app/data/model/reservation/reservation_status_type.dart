enum ReservationStatusType {
  REQUEST,
  CONFIRMED,
  REJECTED;

  static ReservationStatusType fromString(String? type) {
    switch (type) {
      case 'REQUEST':
        return REQUEST;
      case 'CONFIRMED':
        return CONFIRMED;
      case 'REJECTED':
        return REJECTED;
      default:
        return REQUEST;
    }
  }
}
