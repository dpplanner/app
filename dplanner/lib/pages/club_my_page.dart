import 'package:cached_network_image/cached_network_image.dart';
import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/models/reservation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/size.dart';
import '../services/reservation_api_service.dart';
import '../const/style.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/reservation_mini_card.dart';
import 'error_page.dart';

class ClubMyPage extends StatefulWidget {
  const ClubMyPage({super.key});

  @override
  State<ClubMyPage> createState() => _ClubMyPageState();
}

class _ClubMyPageState extends State<ClubMyPage> {
  Future<List<ReservationModel>> getMyReservation() async {
    try {
      return await ReservationApiService.getMyReservations(
          page: 0, status: 'upcoming');
    } catch (e) {
      print(e.toString());
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: AppColor.backgroundColor,
            scrolledUnderElevation: 0,
            leadingWidth: SizeController.to.screenWidth * 0.2,
            title: const Text(
              "마이페이지",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColor.backgroundColor2,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: ClipOval(
                            child: MemberController.to.clubMember().url != null
                                ? CachedNetworkImage(
                                    placeholder: (context, url) => Container(),
                                    imageUrl:
                                        "http://${MemberController.to.clubMember().url!}",
                                    errorWidget: (context, url, error) =>
                                        SvgPicture.asset(
                                          'assets/images/base_image/base_member_image.svg',
                                        ),
                                    height:
                                        SizeController.to.screenWidth * 0.25,
                                    width: SizeController.to.screenWidth * 0.25,
                                    fit: BoxFit.cover)
                                : SvgPicture.asset(
                                    'assets/images/base_image/base_member_image.svg',
                                    height:
                                        SizeController.to.screenWidth * 0.25,
                                    width: SizeController.to.screenWidth * 0.25,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/my_profile');
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      SFSymbols.pencil,
                                      color: AppColor.textColor2,
                                      size: 18,
                                    ),
                                    Text(
                                      "프로필 편집하기",
                                      style: TextStyle(
                                          color: AppColor.textColor2,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                MemberController.to.clubMember().name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                              Text(
                                MemberController.to.clubMember().info ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                selectButton("내 예약 목록", () {
                  Get.toNamed('/my_reservation');
                }, true),
                FutureBuilder<List<ReservationModel>>(
                    future: getMyReservation(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ReservationModel>> snapshot) {
                      if (snapshot.hasError) {
                        return const ErrorPage();
                      } else if (snapshot.data?.isEmpty ?? false) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColor.backgroundColor2,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  "최근 예약이 없어요",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(
                                    snapshot.data?.length ?? 0,
                                    (index) {
                                      final startDate = DateTime.parse(
                                          snapshot.data![index].startDateTime);
                                      final now = DateTime.now();
                                      final today = DateTime(
                                          now.year, now.month, now.day);
                                      final reservationDate = DateTime(
                                          startDate.year,
                                          startDate.month,
                                          startDate.day);
                                      final difference = reservationDate
                                          .difference(today)
                                          .inDays;
                                      final startTime = DateTime.parse(
                                          snapshot.data![index].startDateTime);
                                      var endTime = DateFormat.H().format(
                                          DateTime.parse(snapshot
                                              .data![index].endDateTime));
                                      if (endTime == "00") {
                                        endTime = "24";
                                      }
                                      if (endTime.startsWith("0")) {
                                        endTime = endTime.substring(1);
                                      }
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: ReservationMiniCard(
                                          title:
                                              "${DateFormat("MM/dd H~", 'ko_KR').format(startTime)}$endTime (${snapshot.data![index].resourceName})",
                                          isToday: difference == 0,
                                          isAccepted:
                                              snapshot.data![index].status ==
                                                  "CONFIRMED",
                                          name: snapshot.data![index]
                                                      .clubMemberId ==
                                                  MemberController.to
                                                      .clubMember()
                                                      .id
                                              ? null
                                              : snapshot
                                                  .data![index].clubMemberName,
                                        ),
                                      );
                                    },
                                  ))),
                        );
                      }
                    }),
                selectButton("내 활동 보기", () {
                  Get.toNamed('/my_activity');
                }, true),
                Container(
                  height: SizeController.to.screenHeight * 0.01,
                  color: AppColor.backgroundColor2,
                ),
                selectButton("클럽 정보", () {
                  Get.toNamed('/club_info', arguments: 2);
                }, false),
                if (MemberController.to.clubMember().role == "ADMIN" ||
                    MemberController.to.clubMember().role == "MANAGER")
                  selectButton("클럽 관리", () {
                    Get.toNamed('/club_manage');
                  }, false),
                selectButton("클럽 목록", () {
                  Get.offAllNamed('/club_list');
                }, false),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomBar());
  }

  Widget selectButton(
    String title,
    void Function()? onTap,
    bool isIcon,
  ) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: AppColor.textColor,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        backgroundColor: AppColor.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textColor),
            ),
            if (isIcon)
              const Icon(
                SFSymbols.chevron_right,
                size: 20,
                color: AppColor.textColor,
              ),
          ],
        ),
      ),
    );
  }
}
