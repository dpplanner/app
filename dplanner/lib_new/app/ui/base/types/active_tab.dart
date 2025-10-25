enum ActiveTab {
  TIMETABLE(0),
  HOME(1),
  MY_PAGE(2);

  final int tabIndex;

  const ActiveTab(this.tabIndex);

  static const String _paramKey = "activeTab";
  static final _paramMap = Map.fromEntries(ActiveTab.values.map((tab) => MapEntry(tab.name, tab)));
  static final _indexMap =
      Map.fromEntries(ActiveTab.values.map((tab) => MapEntry(tab.tabIndex, tab)));

  Map<String, String> toParam() {
    return {_paramKey: name};
  }

  static ActiveTab fromParam(Map<String, String?> param) {
    return _paramMap[param[_paramKey]] ?? HOME;
  }

  static ActiveTab fromIndex(int index) {
    return _indexMap[index] ?? HOME;
  }
}
