import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../../../../config/routings/routes.dart';
import '../types/active_tab.dart';

class BaseBottomBar extends StatelessWidget {
  const BaseBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ActiveTab currentTab = ActiveTab.fromParam(Get.parameters);
    final routes = {
      ActiveTab.TIMETABLE: Routes.TIMETABLE,
      ActiveTab.HOME: Routes.POST_LIST,
      ActiveTab.MY_PAGE: Routes.MY_PAGE
    };

    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(SFSymbols.calendar), label: '예약'),
        BottomNavigationBarItem(icon: Icon(SFSymbols.house), label: '클럽 소식'),
        BottomNavigationBarItem(icon: Icon(SFSymbols.person), label: '마이페이지'),
      ],
      currentIndex: currentTab.tabIndex,
      onTap: (index) {
        final destinationTab = ActiveTab.fromIndex(index);
        if (currentTab != destinationTab) {
          Get.offNamed(routes[destinationTab] ?? Routes.POST_LIST,
              parameters: destinationTab.toParam());
        }
      },
    );
  }
}
