import 'dart:async';

import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/services/reservation_api_service.dart';
import 'package:flutter/material.dart';

import '../controllers/member.dart';
import '../models/reservation_model.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/reservation_admin_card.dart';
import 'error_page.dart';
import 'loading_page.dart';

class ClubReservationListTab3Page extends StatefulWidget {
  const ClubReservationListTab3Page({super.key});

  @override
  State<ClubReservationListTab3Page> createState() =>
      _ClubReservationListTab3PageState();
}

class _ClubReservationListTab3PageState
    extends State<ClubReservationListTab3Page> {
  final StreamController<List<ReservationModel>> _rejectedRController =
      StreamController<List<ReservationModel>>();

  final List<ReservationModel> _rejectedReservations = [];
  int _currentPage = 0;
  bool _hasNextPage = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRejectedReservations();
  }

  @override
  void dispose() {
    _rejectedRController.close();
    super.dispose();
  }

  Future<void> _fetchRejectedReservations() async {
    if (!_hasNextPage) return; // 다음 페이지가 없으면 요청을 중단합니다.
    setState(() {
      _isLoading = true; // 데이터를 불러오는 중임을 표시합니다.
    });
    if (_currentPage == 0) _rejectedReservations.clear();

    final rejectedReservations =
        await ReservationApiService.getAdminReservations(
            page: _currentPage++,
            status: 'REJECTED',
            clubId: ClubController.to.club().id);
    setState(() {
      _isLoading = false; // 데이터 불러오기가 완료되었음을 표시합니다.
    });

    if (rejectedReservations.isNotEmpty) {
      setState(() {
        _rejectedReservations.addAll(rejectedReservations);
      });
      _rejectedRController.add(_rejectedReservations);
    } else {
      _hasNextPage = false; // 받아온 포스트가 없다면, 다음 페이지가 없는 것으로 간주합니다.
    }
  }

  void _onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification &&
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      _fetchRejectedReservations(); // 스크롤이 끝에 도달하면 다음 페이지의 포스트를 로드
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
                  _fetchRejectedReservations();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      _onScrollNotification(scrollInfo);
                      return true;
                    },
                    child: StreamBuilder<List<ReservationModel>>(
                        stream: _rejectedRController.stream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ReservationModel>> snapshot) {
                          if (!(MemberController.to.clubMember().role == "ADMIN"
                              || (MemberController.to.clubMember().clubAuthorityTypes != null
                                  && MemberController.to.clubMember().clubAuthorityTypes!.contains("SCHEDULE_ALL")))
                          ) {
                            return Column(
                              children: [
                                const BannerAdWidget(),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minHeight: constraints.maxHeight - 50),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          "권한이 없습니다",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.data == null && !_isLoading) {
                            return Column(
                              children: [
                                const BannerAdWidget(),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minHeight: constraints.maxHeight - 50),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          "거절한 예약이 없어요",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return ErrorPage(constraints: constraints);
                          } else if (snapshot.connectionState ==
                                  ConnectionState.waiting &&
                              snapshot.hasData == false) {
                            return LoadingPage(constraints: constraints);
                          } else {
                            return Column(
                              children: [
                                const BannerAdWidget(),
                                const SizedBox(height: 8,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                                  child: Column(
                                    children: List.generate(
                                      snapshot.data!.length,
                                      (index) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12.0),
                                        child: ReservationAdminCard(
                                          type: 3,
                                          reservation: snapshot.data![index],
                                          onTap: () async {
                                            setState(() {
                                              _currentPage = 0;
                                            });
                                            _fetchRejectedReservations();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        }),
                  ),
                ))));
  }
}
