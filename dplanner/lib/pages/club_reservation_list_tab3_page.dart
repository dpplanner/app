import 'dart:async';

import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/services/reservation_api_service.dart';
import 'package:flutter/material.dart';

import '../controllers/size.dart';
import '../models/reservation_model.dart';
import '../widgets/reservation_admin_card.dart';
import 'error_page.dart';

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
        child: RefreshIndicator(
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
                      if (snapshot.hasData == false) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const ErrorPage();
                      } else if (snapshot.data!.isEmpty && !_isLoading) {
                        return Column(
                          children: [
                            SizedBox(
                              height: SizeController.to.screenHeight * 0.4,
                            ),
                            const Center(
                              child: Text(
                                "거절한 예약이 없어요",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: List.generate(
                              snapshot.data!.length,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: ReservationAdminCard(
                                  type: 3,
                                  reservation: snapshot.data![index],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }),
              ),
            )));
  }
}
