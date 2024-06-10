
class ReportMessage {
  static const String commonWarningMessage = "모든 신고는 철저히 검토되며, 허위 신고는 계정 제재로 이어질 수 있습니다. \n신고는 해당 콘텐츠가 앱의 가이드라인을 위반하는 경우에만 제출해 주세요.";
  static const Map<String, String> _map = {
    "스팸 및 광고": "상업적 목적의 불필요한 광고, \n반복적인 메시지 등",
    "혐오 발언 및 차별": "인종, 성별, 성적 지향, \n종교 등에 기반한 혐오 발언",
    "폭력 및 위협": "폭력적인 내용이나 타인에게 \n위협을 가하는 발언",
    "음란물 및 성적 콘텐츠": "부적절한 성적 콘텐츠 또는 음란물",
    "사기 및 피싱": "금전적 사기, 개인정보 유출 시도",
    "허위 정보 및 가짜 뉴스": "사실이 아닌 정보를 유포하여 \n오도하는 내용",
    "저작권 침해": "타인의 저작물을 \n무단으로 게시하는 경우",
    "개인정보 노출": "타인의 개인정보를 \n무단으로 공개하는 경우",
    "괴롭힘 및 사이버 불링": "특정 개인을 지속적으로 \n괴롭히거나, 모욕하는 행위",
    "부적절한 내용": "커뮤니티 가이드라인에 맞지 않는 \n기타 부적절한 내용"
  };

  static List<String> types() {
    return _map.keys.toList(growable: false);
  }

  static String getValue(String key) {
    return _map[key]!;
  }
}