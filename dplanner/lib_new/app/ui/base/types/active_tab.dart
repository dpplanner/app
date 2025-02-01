enum ActiveTab {
  TIMETABLE,
  HOME,
  MY_PAGE;

  static const String _paramKey = "activeTab";

  Map<String, String> toParam() {
    return {_paramKey: name};
  }

  static ActiveTab fromParam(Map<String, String>? param) {
    switch (param?[_paramKey]) {
      case "TIMETABLE": return ActiveTab.TIMETABLE;
      case "HOME": return ActiveTab.HOME;
      case "MY_PAGE": return ActiveTab.MY_PAGE;
      default: return ActiveTab.HOME;
    }
  }
}
