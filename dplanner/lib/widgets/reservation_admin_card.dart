import 'package:dplanner/controllers/size.dart';
import 'package:dplanner/models/reservation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../style.dart';

class ReservationAdminCard extends StatelessWidget {
  final int type;
  final ReservationModel reservation;

  const ReservationAdminCard(
      {super.key, required this.type, required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      "요청 일시:  ",
                      style: TextStyle(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    Text(
                      "${DateFormat("yy.MM.dd hh:00 -", 'ko_KR').format(DateTime.parse(reservation.startDateTime))} ${reservation.endDateTime.substring(11, 16)}",
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
    );
  }
}
