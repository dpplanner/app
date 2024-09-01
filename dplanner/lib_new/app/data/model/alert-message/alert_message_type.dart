enum AlertMessageType {
  REQUEST,
  NOTICE,
  REPORT,
  ACCEPT,
  REJECT,
  INFO;

  static AlertMessageType fromString(String? type) {
    switch (type) {
      case 'REQUEST':
        return REQUEST;
      case 'NOTICE':
        return NOTICE;
      case 'REPORT':
        return REPORT;
      case 'ACCEPT':
        return ACCEPT;
      case 'REJECT':
        return REJECT;
      case 'INFO':
        return INFO;
      default:
        return INFO;
    }
  }

  String getLowerCase() {
    return name.toLowerCase();
  }
}
