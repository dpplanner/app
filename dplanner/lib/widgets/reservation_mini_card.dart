import 'package:flutter/material.dart';

import '../const/style.dart';

class ReservationMiniCard extends StatelessWidget {
  final String title;
  final bool isToday;
  final bool isAccepted;
  final String? name;

  const ReservationMiniCard(
      {super.key,
      required this.title,
      required this.isToday,
      required this.isAccepted,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isToday ? AppColor.subColor2 : AppColor.subColor4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: AppColor.textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                Text(
                  name == null
                      ? "내 예약${(isAccepted) ? "" : " - 승인 대기중"}"
                      : "$name의 예약${(isAccepted) ? "" : " - 승인 대기중"}",
                  style: const TextStyle(
                      color: AppColor.textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
