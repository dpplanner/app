import 'package:cached_network_image/cached_network_image.dart';
import 'package:dplanner/controllers/size.dart';
import 'package:dplanner/models/reservation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../const/style.dart';
import 'full_screen_image.dart';

class ReservationReturnCard extends StatelessWidget {
  final ReservationModel reservation;

  const ReservationReturnCard({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColor.subColor2.withOpacity(0.5),
      highlightColor: AppColor.subColor2.withOpacity(0.5),
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (reservation.returned) {
          getReturnInfo(reservation: reservation);
        }
      },
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColor.backgroundColor,
        ),
        child: Container(
          width: SizeController.to.screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColor.backgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: Visibility(
              visible: reservation.returned,
              replacement: const Text(
                "아직 작성된 반납 정보가 없어요",
                style: TextStyle(
                    color: AppColor.textColor2,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              child: Row(
                children: [
                  Text(
                    reservation.clubMemberName,
                    style: const TextStyle(
                        color: AppColor.textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  ),
                  const Text(
                    " 님이 반납 정보를 작성했어요",
                    style: TextStyle(
                        color: AppColor.textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getReturnInfo({required ReservationModel reservation}) async {
    Get.bottomSheet(
      isScrollControlled: true,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: SizeController.to.screenHeight * 0.7,
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                        child: SvgPicture.asset(
                          'assets/images/extra/showmodal_scrollcontrolbar.svg',
                        ),
                      ),
                      const Text(
                        "반납 정보",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "신청자",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                              Text(
                                reservation.clubMemberName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 32, bottom: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "물품",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                Text(
                                  reservation.resourceName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "신청 시간",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                              Text(
                                "${DateFormat("yy.MM.dd  HH:00-", 'ko_KR').format(DateTime.parse(reservation.startDateTime))}${reservation.endDateTime.substring(11, 16)}",
                                style: const TextStyle(
                                    color: AppColor.textColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 32, bottom: 16),
                            child: Text(
                              "물품 사진",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 120,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children:
                                  reservation.attachmentsUrl.map((imageUrl) {
                                String formattedUrl =
                                    imageUrl.startsWith('https://')
                                        ? imageUrl
                                        : 'https://$imageUrl';
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => FullScreenImage(
                                          imageUrl: formattedUrl));
                                    },
                                    child: Stack(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1 / 1,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      Container(),
                                                  imageUrl: formattedUrl,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          SvgPicture.asset(
                                                            'assets/images/base_image/base_post_image.svg',
                                                          ),
                                                  fit: BoxFit.cover)),
                                        ),
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: const Alignment(0.0, 0.6),
                                                colors: [
                                                  AppColor.objectColor,
                                                  AppColor.objectColor
                                                      .withOpacity(0.9),
                                                  AppColor.objectColor
                                                      .withOpacity(0.7),
                                                  AppColor.objectColor
                                                      .withOpacity(0.5),
                                                  AppColor.objectColor
                                                      .withOpacity(0.3),
                                                  AppColor.objectColor
                                                      .withOpacity(0.1),
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Positioned(
                                          bottom: 3,
                                          right: 7,
                                          child: Text(
                                            "자세히 보기",
                                            style: TextStyle(
                                                color:
                                                    AppColor.backgroundColor2,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          if (reservation.returnMessage != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 32, bottom: 16),
                                  child: Text(
                                    "반납 메시지",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                ),
                                Text(
                                  reservation.returnMessage ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
      backgroundColor: AppColor.backgroundColor,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
    );
  }
}
