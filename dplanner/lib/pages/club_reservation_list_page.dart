import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:dplanner/pages/club_reservation_list_tab1_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import 'club_reservation_list_tab2_page.dart';
import 'club_reservation_list_tab3_page.dart';

class ClubReservationListPage extends StatefulWidget {
  const ClubReservationListPage({super.key});

  @override
  State<ClubReservationListPage> createState() =>
      _ClubReservationListPageState();
}

class _ClubReservationListPageState extends State<ClubReservationListPage> {
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
            "예약 요청",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: ContainedTabBarView(
        tabs: const [
          Text(
            "승인 대기중",
          ),
          Text(
            "승인한 예약",
          ),
          Text(
            "거절한 예약",
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
          ClubReservationListTab1Page(),
          ClubReservationListTab2Page(),
          ClubReservationListTab3Page(),
        ],
      ),
    );
  }
}
