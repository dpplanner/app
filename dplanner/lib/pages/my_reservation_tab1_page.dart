import 'dart:async';

import 'package:dplanner/services/reservation_api_service.dart';
import 'package:dplanner/widgets/reservation_big_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/reservation_model.dart';
import '../style.dart';
import 'error_page.dart';
import 'loading_page.dart';

class MyReservationTab1Page extends StatefulWidget {
  const MyReservationTab1Page({super.key});

  @override
  State<MyReservationTab1Page> createState() => _MyReservationTab1PageState();
}

class _MyReservationTab1PageState extends State<MyReservationTab1Page> {
  String lastDay = '';

  final StreamController<List<ReservationModel>> _upcomingRController =
      StreamController<List<ReservationModel>>();

  final List<ReservationModel> _upcomingReservations = [];
  int _currentPage = 0;
  bool _hasNextPage = true;

  @override
  void initState() {
    super.initState();
    _fetchUpcomingReservations();
  }

  @override
  void dispose() {
    _upcomingRController.close();
    super.dispose();
  }

  Future<void> _fetchUpcomingReservations() async {
    if (!_hasNextPage) return; // 다음 페이지가 없으면 요청을 중단합니다.
    if (_currentPage == 0) _upcomingReservations.clear();

    final upcomingReservations = await ReservationApiService.getMyReservations(
        page: _currentPage++, status: 'upcoming');

    if (upcomingReservations.isNotEmpty) {
      setState(() {
        _upcomingReservations.addAll(upcomingReservations);
      });
      _upcomingRController.add(_upcomingReservations);
    } else {
      _hasNextPage = false; // 받아온 포스트가 없다면, 다음 페이지가 없는 것으로 간주합니다.
    }
  }

  void _onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification &&
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      _fetchUpcomingReservations(); // 스크롤이 끝에 도달하면 다음 페이지의 포스트를 로드
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
                  _fetchUpcomingReservations();
                },
                child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        _onScrollNotification(scrollInfo);
                        return true;
                      },
                      child: StreamBuilder<List<ReservationModel>>(
                          stream: _upcomingRController.stream,
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
                                        "다가오는 예약이 없어요",
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
                              List<ReservationModel> data = _addEmptyReservation(snapshot.data!);
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(24, 24, 24, 24),
                                child: Column(
                                  children: List.generate(data.length,
                                      (index) {

                                    final difference = _getDateDiffFromNow(data[index]);

                                    String dateText;
                                    bool isWritten = false;
                                    if (difference == 0) {
                                      dateText = "오늘";
                                    } else if (difference == 1) {
                                      dateText = "내일";
                                    } else {
                                      dateText = "그외";
                                    }

                                    if (index != 0 && lastDay == dateText) {
                                      isWritten = true;
                                    }
                                    lastDay = dateText;

                                    var endTime = DateFormat.H().format(
                                        DateTime.parse(
                                            data[index].endDateTime));
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
                                              onTap: () async {
                                                setState(() {
                                                  _currentPage = 0;
                                                  lastDay = '';
                                                });
                                                _fetchUpcomingReservations();
                                              },
                                              reservation: data[index],
                                              isRecent: dateText == "오늘",
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
                    )
                )
            )
        )
    );
  }

  int _getDateDiffFromNow(ReservationModel reservation) {
    final startDate = DateTime.parse(reservation.startDateTime);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final reservationDate = DateTime(startDate.year, startDate.month, startDate.day);

    return reservationDate.difference(today).inDays;
  }

  List<ReservationModel> _addEmptyReservation(List<ReservationModel> data) {
    // 오늘 : diff = 0, 내일 : diff = 1, 그외 : diff > 1
    // case0. 오늘 0 내일 0 그외 0 -> 오늘, 내일, 모레 날짜로 빈 예약 하나씩 추가
    // case1. 오늘 0 내일 0 그외 n -> 오늘, 내일 날짜로 빈 예약 하나씩 추가
    // case2. 오늘 0 내일 n 그외 m -> 오늘 날짜로 빈 예약 하나 추가
    // case3. 오늘 n 내일 0 그외 m -> 내일 날짜로 빈 예약 하나 추가
    // case4. 오늘 n 내일 m 그외 l -> 별도 처리 불필요

    List<ReservationModel> processedData = [];
    var now = DateTime.now();

    // 오늘 예약이 없는 경우
    int idxToday = data.indexWhere((reservation) => _getDateDiffFromNow(reservation) == 0);
    if (idxToday < 0) {
      var today = DateTime(now.year, now.month, now.day, 12, 00, 00).toString().split('.')[0];
      processedData.add(ReservationModel.ofDummy(today, today));
    }

    // 내일 예약이 없는 경우
    int idxTomorrow = data.indexWhere((reservation) => _getDateDiffFromNow(reservation) == 1);
    if (idxTomorrow < 0) {
      var tomorrow = DateTime(now.year, now.month, now.day + 1, 12, 00, 00).toString().split('.')[0];
      processedData.add(ReservationModel.ofDummy(tomorrow, tomorrow));
    }

    // 그외 예약이 없는 경우
    int idxAfterTomorrow = data.indexWhere((reservation) => _getDateDiffFromNow(reservation) > 1);
    if (idxAfterTomorrow < 0) {
      var afterTomorrow = DateTime(now.year, now.month, now.day + 2, 12, 00, 00).toString().split('.')[0];
      processedData.add(ReservationModel.ofDummy(afterTomorrow, afterTomorrow));
    }

    // 실제 데이터 추가 후 정렬
    processedData.addAll(data);
    processedData.sort((a, b) => DateTime.parse(a.startDateTime).compareTo(DateTime.parse(b.startDateTime)));

    return processedData;
  }
}
