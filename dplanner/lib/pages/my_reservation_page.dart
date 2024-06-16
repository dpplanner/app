import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../const/style.dart';
import 'my_reservation_tab1_page.dart';
import 'my_reservation_tab2_page.dart';
import 'my_reservation_tab3_page.dart';

class MyReservationPage extends StatefulWidget {
  const MyReservationPage({super.key});

  @override
  State<MyReservationPage> createState() => _MyReservationPageState();
}

class _MyReservationPageState extends State<MyReservationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor2,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColor.backgroundColor,
          scrolledUnderElevation: 0,
          leadingWidth: SizeController.to.screenWidth * 0.2,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(SFSymbols.chevron_left)),
          title: const Text(
            "내 예약 목록",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: ContainedTabBarView(
        tabs: const [
          Text(
            "다가오는 예약",
          ),
          Text(
            "지난 예약",
          ),
          Text(
            "거절된 예약",
          ),
        ],
        tabBarProperties: TabBarProperties(
            background: Container(color: AppColor.backgroundColor),
            height: 48.0,
            indicatorColor: AppColor.objectColor,
            indicatorWeight: 3.0,
            labelColor: AppColor.objectColor,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            unselectedLabelColor: AppColor.textColor,
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        views: const [
          MyReservationTab1Page(),
          MyReservationTab2Page(),
          MyReservationTab3Page()
        ],
        initialIndex: getInitialTab(),
      ),
    );
  }

  int getInitialTab() {
    Map<String, String?> params = Get.parameters;

    // 거절된 예약
    if (params.containsKey("rejected") && params["rejected"] != null && bool.parse(params["rejected"]!) == true) {
      return 2;
    }

    // 지난 예약
    if (params.containsKey("isPast") && params["isPast"] != null && bool.parse(params["isPast"]!) == true) {
      return 1;
    }

    // 다가오는 예약(default)
    return 0;
  }
}
