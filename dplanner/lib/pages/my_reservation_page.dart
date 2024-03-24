import 'dart:async';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:dplanner/services/reservation_api_service.dart';
import 'package:dplanner/widgets/reservation_big_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/size.dart';
import '../models/reservation_model.dart';
import '../style.dart';
import 'error_page.dart';

class MyReservationPage extends StatefulWidget {
  const MyReservationPage({super.key});

  @override
  State<MyReservationPage> createState() => _MyReservationPageState();
}

class _MyReservationPageState extends State<MyReservationPage> {
  bool isMoreRequesting = false;
  int nextPage = 0;
  String lastDay = '';

  Future<List<ReservationModel>>? upcomingReservations;
  Future<List<ReservationModel>>? previousReservations;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void loadInitialData() {
    upcomingReservations =
        ReservationApiService.getMyReservations(page: 0, status: 'upcoming');
    previousReservations =
        ReservationApiService.getMyReservations(page: 0, status: 'previous');
  }

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
        views: [
          SafeArea(
              child: RefreshIndicator(onRefresh: () async {
            setState(() {
              upcomingReservations = ReservationApiService.getMyReservations(
                  page: 0, status: 'upcoming');
            });
            ;
          }, child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: FutureBuilder<List<ReservationModel>>(
                    key: UniqueKey(),
                    future: upcomingReservations,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ReservationModel>> snapshot) {
                      if (snapshot.hasData == false) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const ErrorPage();
                      } else {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(18, 24, 24, 24),
                          child: Column(
                            children:
                                List.generate(snapshot.data!.length, (index) {
                              final startDate = DateTime.parse(
                                  snapshot.data![index].startDateTime);
                              final now = DateTime.now();
                              final today =
                                  DateTime(now.year, now.month, now.day);
                              final reservationDate = DateTime(startDate.year,
                                  startDate.month, startDate.day);
                              final difference =
                                  reservationDate.difference(today).inDays;

                              String dateText;
                              bool isWritten = false;
                              if (difference == 0) {
                                dateText = "오늘";
                              } else if (difference == 1) {
                                dateText = "내일";
                              } else if (difference == -1) {
                                dateText = "어제";
                              } else {
                                dateText = "그외";
                              }

                              if (lastDay == dateText) {
                                isWritten = true;
                              }
                              lastDay = dateText;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 5, 18, 0),
                                      child: Text(
                                        dateText,
                                        style: TextStyle(
                                            color: isWritten
                                                ? AppColor.backgroundColor2
                                                : AppColor.textColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                    ),
                                    Expanded(
                                      child: ReservationBigCard(
                                          time:
                                              "${DateFormat("yyyy년 MM월 dd일 hh:00 -", 'ko_KR').format(DateTime.parse(snapshot.data![index].startDateTime))} ${snapshot.data![index].endDateTime.substring(11, 16)}",
                                          resource: snapshot
                                              .data![index].resourceName,
                                          name:
                                              "${snapshot.data![index].clubMemberName}의 예약",
                                          isRecent: index == 0),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        );
                      }
                    }));
          }))),
          SafeArea(
              child: RefreshIndicator(onRefresh: () async {
            setState(() {
              previousReservations = ReservationApiService.getMyReservations(
                  page: 0, status: 'previous');
            });
          }, child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: FutureBuilder<List<ReservationModel>>(
                    key: UniqueKey(),
                    future: previousReservations,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ReservationModel>> snapshot) {
                      if (snapshot.hasData == false) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const ErrorPage();
                      } else {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(18, 24, 24, 24),
                          child: Column(
                            children:
                                List.generate(snapshot.data!.length, (index) {
                              final startDate = DateTime.parse(
                                  snapshot.data![index].startDateTime);
                              final now = DateTime.now();
                              final today =
                                  DateTime(now.year, now.month, now.day);
                              final reservationDate = DateTime(startDate.year,
                                  startDate.month, startDate.day);
                              final difference =
                                  reservationDate.difference(today).inDays;

                              String dateText;
                              bool isWritten = false;
                              if (difference == 0) {
                                dateText = "오늘";
                              } else if (difference == 1) {
                                dateText = "내일";
                              } else if (difference == -1) {
                                dateText = "어제";
                              } else {
                                dateText = "그외";
                              }

                              if (lastDay == dateText) {
                                isWritten = true;
                              }
                              lastDay = dateText;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 5, 18, 0),
                                      child: Text(
                                        dateText,
                                        style: TextStyle(
                                            color: isWritten
                                                ? AppColor.backgroundColor2
                                                : AppColor.textColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                    ),
                                    Expanded(
                                      child: ReservationBigCard(
                                          time:
                                              "${DateFormat("yyyy년 MM월 dd일 hh:00 -", 'ko_KR').format(DateTime.parse(snapshot.data![index].startDateTime))} ${snapshot.data![index].endDateTime.substring(11, 16)}",
                                          resource: snapshot
                                              .data![index].resourceName,
                                          name:
                                              "${snapshot.data![index].clubMemberName}의 예약",
                                          isRecent: false),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        );
                      }
                    }));
          }))),
        ],
      ),
    );
  }
}
