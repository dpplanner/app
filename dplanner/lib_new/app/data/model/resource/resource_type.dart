enum ResourceType {
  PLACE,
  THING;

  static ResourceType fromString(String? type) {
    switch (type) {
      case 'PLACE':
        return PLACE;
      case 'THING':
        return THING;
      default:
        return PLACE;
    }
  }
}
