import 'package:flutter/material.dart';

import '../style.dart';

class ReservationMiniCard extends StatelessWidget {
  final String title;
  final bool isAccepted;
  final String name;

  const ReservationMiniCard(
      {super.key,
      required this.title,
      required this.isAccepted,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.subColor2,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$title - ${(isAccepted) ? "승인됨" : "승인 대기중"}",
              style: const TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            Text(
              name,
              style: const TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
