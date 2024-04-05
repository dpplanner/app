import 'dart:async';

import 'package:dplanner/services/reservation_api_service.dart';
import 'package:dplanner/widgets/reservation_big_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/size.dart';
import '../models/reservation_model.dart';
import '../style.dart';
import 'error_page.dart';
import 'loading_page.dart';

class MyReservationTab2Page extends StatefulWidget {
  const MyReservationTab2Page({super.key});

  @override
  State<MyReservationTab2Page> createState() => _MyReservationTab2PageState();
}

class _MyReservationTab2PageState extends State<MyReservationTab2Page> {
  String lastDay = '';

  final StreamController<List<ReservationModel>> _previousRController =
      StreamController<List<ReservationModel>>();

  final List<ReservationModel> _previousReservations = [];
  int _currentPage = 0;
  bool _hasNextPage = true;

  @override
  void initState() {
    super.initState();
    _fetchPreviousReservations();
  }

  @override
  void dispose() {
    _previousRController.close();
    super.dispose();
  }

  Future<void> _fetchPreviousReservations() async {
    if (!_hasNextPage) return; // 다음 페이지가 없으면 요청을 중단합니다.
    if (_currentPage == 0) _previousReservations.clear();

    final previousReservations = await ReservationApiService.getMyReservations(
        page: _currentPage++, status: 'previous');

    if (previousReservations.isNotEmpty) {
      setState(() {
        _previousReservations.addAll(previousReservations);
      });
      _previousRController.add(_previousReservations);
    } else {
      _hasNextPage = false; // 받아온 포스트가 없다면, 다음 페이지가 없는 것으로 간주합니다.
    }
  }

  void _onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification &&
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      _fetchPreviousReservations(); // 스크롤이 끝에 도달하면 다음 페이지의 포스트를 로드
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: LayoutBuilder(
            builder: (context, constraints) => RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _currentPage = 0;
                    lastDay = '';
                  });
                  _fetchPreviousReservations();
                },
                child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        _onScrollNotification(scrollInfo);
                        return true;
                      },
                      child: StreamBuilder<List<ReservationModel>>(
                          stream: _previousRController.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ReservationModel>> snapshot) {
                            if (snapshot.data == null) {
                              return ConstrainedBox(
                                constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        "지난 예약이 없어요",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return ErrorPage(constraints: constraints);
                            } else if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                snapshot.hasData == false) {
                              return LoadingPage(constraints: constraints);
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(18, 24, 24, 24),
                                child: Column(
                                  children: List.generate(snapshot.data!.length,
                                      (index) {
                                    final startDate = DateTime.parse(
                                        snapshot.data![index].startDateTime);
                                    final now = DateTime.now();
                                    final today =
                                        DateTime(now.year, now.month, now.day);
                                    final reservationDate = DateTime(
                                        startDate.year,
                                        startDate.month,
                                        startDate.day);
                                    final difference = reservationDate
                                        .difference(today)
                                        .inDays;

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

                                    if (index != 0 && lastDay == dateText) {
                                      isWritten = true;
                                    }
                                    lastDay = dateText;

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 5, 18, 0),
                                            child: Text(
                                              dateText,
                                              style: TextStyle(
                                                  color: isWritten
                                                      ? AppColor
                                                          .backgroundColor2
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
                          }),
                    )))));
  }
}
