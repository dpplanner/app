enum LikeStatusType {
  LIKE,
  DISLIKE;

  static LikeStatusType fromString(String? type) {
    switch (type) {
      case 'LIKE':
        return LIKE;
      case 'DISLIKE':
        return DISLIKE;
      default:
        return DISLIKE;
    }
  }
}
