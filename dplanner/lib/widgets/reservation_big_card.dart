import 'package:dplanner/controllers/size.dart';
import 'package:flutter/material.dart';

import '../style.dart';

class ReservationBigCard extends StatelessWidget {
  final String time;
  final String resource;
  final String name;
  final bool isRecent;

  const ReservationBigCard(
      {super.key,
      required this.time,
      required this.resource,
      required this.name,
      this.isRecent = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeController.to.screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isRecent ? AppColor.subColor2 : AppColor.backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: const TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 15),
            ),
            Text(
              resource,
              style: const TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            Text(
              name,
              style: const TextStyle(
                  color: AppColor.textColor2,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
