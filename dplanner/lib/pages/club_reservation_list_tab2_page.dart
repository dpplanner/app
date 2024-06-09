import 'dart:async';

import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/services/reservation_api_service.dart';
import 'package:dplanner/widgets/reservation_return_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import '../models/reservation_model.dart';
import '../style.dart';
import '../widgets/reservation_admin_card.dart';
import 'error_page.dart';
import 'loading_page.dart';

class ClubReservationListTab2Page extends StatefulWidget {
  const ClubReservationListTab2Page({super.key});

  @override
  State<ClubReservationListTab2Page> createState() =>
      _ClubReservationListTab2PageState();
}

class _ClubReservationListTab2PageState
    extends State<ClubReservationListTab2Page> {
  final StreamController<List<ReservationModel>> _confirmedRController =
      StreamController<List<ReservationModel>>();

  final List<ReservationModel> _confirmedReservations = [];
  int _currentPage = 0;
  bool _hasNextPage = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchConfirmedReservations();
  }

  @override
  void dispose() {
    _confirmedRController.close();
    super.dispose();
  }

  Future<void> _fetchConfirmedReservations() async {
    if (!_hasNextPage) return; // 다음 페이지가 없으면 요청을 중단합니다.
    setState(() {
      _isLoading = true; // 데이터를 불러오는 중임을 표시합니다.
    });
    if (_currentPage == 0) _confirmedReservations.clear();

    final confirmedReservations =
        await ReservationApiService.getAdminReservations(
            page: _currentPage++,
            status: 'CONFIRMED',
            clubId: ClubController.to.club().id);
    setState(() {
      _isLoading = false; // 데이터 불러오기가 완료되었음을 표시합니다.
    });

    if (confirmedReservations.isNotEmpty) {
      setState(() {
        _confirmedReservations.addAll(confirmedReservations);
      });
      _confirmedRController.add(_confirmedReservations);
    } else {
      _hasNextPage = false; // 받아온 포스트가 없다면, 다음 페이지가 없는 것으로 간주합니다.
    }
  }

  void _onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification &&
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      _fetchConfirmedReservations(); // 스크롤이 끝에 도달하면 다음 페이지의 포스트를 로드
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
                  });
                  _fetchConfirmedReservations();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      _onScrollNotification(scrollInfo);
                      return true;
                    },
                    child: StreamBuilder<List<ReservationModel>>(
                        stream: _confirmedRController.stream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ReservationModel>> snapshot) {
                          if (snapshot.data == null && !_isLoading) {
                            return ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      "승인한 예약이 없어요",
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
                                  ConnectionState.waiting &&
                              snapshot.hasData == false) {
                            return LoadingPage(constraints: constraints);
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: List.generate(
                                  snapshot.data!.length,
                                  (index) => Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12.0),
                                        child: ReservationAdminCard(
                                          type: 2,
                                          reservation: snapshot.data![index],
                                          onTap: () async {
                                            setState(() {
                                              _currentPage = 0;
                                            });
                                            _fetchConfirmedReservations();
                                          },
                                        ),
                                      ),
                                      if (DateTime.parse(
                                              snapshot.data![index].endDateTime)
                                          .isBefore(DateTime.now()))
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 12.0),
                                          child: Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: Icon(
                                                    SFSymbols
                                                        .arrow_turn_down_right,
                                                    color: AppColor.subColor3),
                                              ),
                                              Expanded(
                                                  child: ReservationReturnCard(
                                                      reservation: snapshot
                                                          .data![index]))
                                            ],
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                  ),
                ))));
  }
}
