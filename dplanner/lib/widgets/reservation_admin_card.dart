import 'package:dplanner/controllers/size.dart';
import 'package:dplanner/models/reservation_model.dart';
import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../services/reservation_api_service.dart';
import '../style.dart';
import 'nextpage_button.dart';

class ReservationAdminCard extends StatelessWidget {
  final VoidCallback onTap;
  final int type;
  final ReservationModel reservation;

  const ReservationAdminCard(
      {super.key,
      required this.type,
      required this.reservation,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (type == 1) {
          getRequestInfo(reservation: reservation);
        }
      },
      child: Container(
        width: SizeController.to.screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColor.backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3, right: 6),
                child: SvgPicture.asset(
                  type == 1
                      ? 'assets/images/notification_icon/icon_request.svg'
                      : type == 2
                          ? 'assets/images/notification_icon/icon_accept.svg'
                          : 'assets/images/notification_icon/icon_reject.svg',
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        reservation.clubMemberName,
                        style: const TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                      const Text(
                        " 님의",
                        style: TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        reservation.resourceName,
                        style: const TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                      Text(
                        type == 1
                            ? " 예약 요청이 있어요"
                            : type == 2
                                ? " 예약 요청을 승인했어요"
                                : " 예약 요청을 거절했어요",
                        style: const TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "신청 일시:  ",
                        style: TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      Text(
                        "${DateFormat("yy.MM.dd  HH:00-", 'ko_KR').format(DateTime.parse(reservation.startDateTime))}${reservation.endDateTime.substring(11, 16)}",
                        style: const TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getRequestInfo({required ReservationModel reservation}) async {
    bool checkedMore = false;

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
                        "예약 요청",
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
                                "${DateFormat("yy.MM.dd  hh:00-", 'ko_KR').format(DateTime.parse(reservation.startDateTime))}${reservation.endDateTime.substring(11, 16)}",
                                style: const TextStyle(
                                    color: AppColor.textColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 32, bottom: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "요청 시간",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                Text(
                                  DateFormat("yy.MM.dd  hh:mm", 'ko_KR').format(
                                      DateTime.parse(reservation.createDate)),
                                  style: const TextStyle(
                                      color: AppColor.textColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                checkedMore = !checkedMore;
                              });
                            },
                            child: Row(
                              children: [
                                const Text(
                                  "내용 더보기",
                                  style: TextStyle(
                                      color: AppColor.textColor2,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                Icon(
                                  checkedMore
                                      ? SFSymbols.chevron_up
                                      : SFSymbols.chevron_down,
                                  color: AppColor.textColor2,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                          if (checkedMore && reservation.title != "")
                            Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "예약 제목",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    reservation.title,
                                    style: const TextStyle(
                                        color: AppColor.textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          if (checkedMore && reservation.usage != "")
                            Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "사용 용도",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    reservation.usage,
                                    style: const TextStyle(
                                        color: AppColor.textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          if (checkedMore && reservation.invitees.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "함께 사용하는 사람",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  ...reservation.invitees
                                      .map((invitee) => Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Text(
                                              invitee,
                                              style: const TextStyle(
                                                  color: AppColor.textColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                          ))
                                      .toList(),
                                ],
                              ),
                            ),
                          if (checkedMore)
                            Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "물품 공유 여부",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    reservation.sharing ? "가능" : "불가능",
                                    style: const TextStyle(
                                        color: AppColor.textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: NextPageButton(
                          text: const Text(
                            "거절하기",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColor.backgroundColor),
                          ),
                          buttonColor: AppColor.subColor3,
                          onPressed: () async {
                            try {
                              await ReservationApiService.patchReservation(
                                  reservationIds: [reservation.reservationId],
                                  isConfirmed: false);
                            } catch (e) {
                              print(e.toString());
                              snackBar(
                                  title: "예약 거절 실패", content: e.toString());
                            }
                            onTap();
                            Get.back();
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: NextPageButton(
                          text: const Text(
                            "승인하기",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColor.backgroundColor),
                          ),
                          buttonColor: AppColor.objectColor,
                          onPressed: () async {
                            try {
                              await ReservationApiService.patchReservation(
                                  reservationIds: [reservation.reservationId],
                                  isConfirmed: true);
                            } catch (e) {
                              print(e.toString());
                              snackBar(
                                  title: "예약 승인 실패", content: e.toString());
                            }
                            onTap();
                            Get.back();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
