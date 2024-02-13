import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:dplanner/widgets/reservation_big_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';

class ReservationListPage extends StatefulWidget {
  const ReservationListPage({super.key});

  @override
  State<ReservationListPage> createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColor.backgroundColor,
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
            "모든 예약",
          ),
          Text(
            "내 예약",
          ),
          Text(
            "초대받은 예약",
          ),
        ],
        tabBarProperties: const TabBarProperties(
            height: 40.0,
            indicatorColor: AppColor.objectColor,
            indicatorWeight: 2.0,
            labelColor: AppColor.objectColor,
            labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            unselectedLabelColor: AppColor.textColor,
            unselectedLabelStyle:
                TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        views: [
          Container(
            color: AppColor.backgroundColor2,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(18, 24, 24, 24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 18, 0),
                            child: Expanded(
                              flex: 1,
                              child: Text(
                                "오늘",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: ReservationBigCard(
                                time: "12.23 18:00 - 20:00",
                                resource: "동아리 방 - 학생회관(107관 611호)",
                                name: "DP23 남진의 예약",
                                isRecent: true),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 18, 0),
                            child: Expanded(
                              flex: 1,
                              child: Text(
                                "오늘",
                                style: TextStyle(
                                    color: Colors.transparent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: ReservationBigCard(
                              time: "12.23 18:00 - 20:00",
                              resource: "동아리 방 - 학생회관(107관 611호)",
                              name: "DP23 남진의 예약",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 18, 0),
                            child: Expanded(
                              flex: 1,
                              child: Text(
                                "내일",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: ReservationBigCard(
                              time: "12.23 18:00 - 20:00",
                              resource: "동아리 방 - 학생회관(107관 611호)",
                              name: "DP23 남진의 예약",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 18, 0),
                            child: Expanded(
                              flex: 1,
                              child: Text(
                                "그외",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: ReservationBigCard(
                              time: "12.23 18:00 - 20:00",
                              resource: "동아리 방 - 학생회관(107관 611호)",
                              name: "DP23 남진의 예약",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 18, 0),
                            child: Expanded(
                              flex: 1,
                              child: Text(
                                "오늘",
                                style: TextStyle(
                                    color: Colors.transparent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: ReservationBigCard(
                              time: "12.23 18:00 - 20:00",
                              resource: "동아리 방 - 학생회관(107관 611호)",
                              name: "DP23 남진의 예약",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 18, 0),
                            child: Expanded(
                              flex: 1,
                              child: Text(
                                "오늘",
                                style: TextStyle(
                                    color: Colors.transparent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: ReservationBigCard(
                              time: "12.23 18:00 - 20:00",
                              resource: "동아리 방 - 학생회관(107관 611호)",
                              name: "DP23 남진의 예약",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 18, 0),
                            child: Expanded(
                              flex: 1,
                              child: Text(
                                "오늘",
                                style: TextStyle(
                                    color: Colors.transparent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: ReservationBigCard(
                              time: "12.23 18:00 - 20:00",
                              resource: "동아리 방 - 학생회관(107관 611호)",
                              name: "DP23 남진의 예약",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 18, 0),
                            child: Expanded(
                              flex: 1,
                              child: Text(
                                "오늘",
                                style: TextStyle(
                                    color: Colors.transparent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: ReservationBigCard(
                              time: "12.23 18:00 - 20:00",
                              resource: "동아리 방 - 학생회관(107관 611호)",
                              name: "DP23 남진의 예약",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 18, 0),
                            child: Expanded(
                              flex: 1,
                              child: Text(
                                "오늘",
                                style: TextStyle(
                                    color: Colors.transparent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: ReservationBigCard(
                              time: "12.23 18:00 - 20:00",
                              resource: "동아리 방 - 학생회관(107관 611호)",
                              name: "DP23 남진의 예약",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: AppColor.backgroundColor2,
          ),
          Container(
            color: AppColor.backgroundColor2,
          ),
        ],
      ),
    );
  }
}
