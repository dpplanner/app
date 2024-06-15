import 'dart:async';

import 'package:dplanner/services/reservation_api_service.dart';
import 'package:dplanner/widgets/reservation_big_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/reservation_model.dart';
import '../const/style.dart';
import 'error_page.dart';
import 'loading_page.dart';

class MyReservationTab3Page extends StatefulWidget {
  const MyReservationTab3Page({super.key});

  @override
  State<MyReservationTab3Page> createState() => _MyReservationTab3PageState();
}

class _MyReservationTab3PageState extends State<MyReservationTab3Page> {
  String lastDay = '';

  final StreamController<List<ReservationModel>> _rejectRController =
      StreamController<List<ReservationModel>>();

  final List<ReservationModel> _rejectReservations = [];
  int _currentPage = 0;
  bool _hasNextPage = true;

  @override
  void initState() {
    super.initState();
    _fetchRejectReservations();
  }

  @override
  void dispose() {
    _rejectRController.close();
    super.dispose();
  }

  Future<void> _fetchRejectReservations() async {
    if (!_hasNextPage) return; // 다음 페이지가 없으면 요청을 중단합니다.
    if (_currentPage == 0) _rejectReservations.clear();

    final rejectReservations = await ReservationApiService.getMyReservations(
        page: _currentPage++, status: 'reject');

    if (rejectReservations.isNotEmpty) {
      setState(() {
        _rejectReservations.addAll(rejectReservations);
      });
      _rejectRController.add(_rejectReservations);
    } else {
      _hasNextPage = false; // 받아온 포스트가 없다면, 다음 페이지가 없는 것으로 간주합니다.
    }
  }

  void _onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification &&
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      _fetchRejectReservations(); // 스크롤이 끝에 도달하면 다음 페이지의 포스트를 로드
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
                  _fetchRejectReservations();
                },
                child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        _onScrollNotification(scrollInfo);
                        return true;
                      },
                      child: StreamBuilder<List<ReservationModel>>(
                          stream: _rejectRController.stream,
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
                                        "거절된 예약이 없어요",
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
                                    const EdgeInsets.fromLTRB(24, 24, 24, 24),
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

                                    var endTime = DateFormat.H().format(
                                        DateTime.parse(
                                            snapshot.data![index].endDateTime));
                                    if (endTime == "00") {
                                      endTime = "24";
                                    }
                                    if (endTime.startsWith("0")) {
                                      endTime = endTime.substring(1);
                                    }

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Padding(
                                          //   padding: const EdgeInsets.fromLTRB(
                                          //       0, 5, 18, 0),
                                          //   child: Text(
                                          //     dateText,
                                          //     style: TextStyle(
                                          //         color: isWritten
                                          //             ? AppColor
                                          //                 .backgroundColor2
                                          //             : AppColor.textColor,
                                          //         fontWeight: FontWeight.w700,
                                          //         fontSize: 16),
                                          //   ),
                                          // ),
                                          Expanded(
                                            child: ReservationBigCard(
                                              onTap: () async {
                                                setState(() {
                                                  _currentPage = 0;
                                                  lastDay = '';
                                                });
                                                _fetchRejectReservations();
                                              },
                                              reservation:
                                                  snapshot.data![index],
                                              isRecent: false,
                                              endTime: endTime,
                                            ),
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
