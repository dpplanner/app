import 'package:dplanner/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotificationCard extends StatelessWidget {
  final String icon;
  final String title;
  final String content;
  final bool isNew;
  final bool isChecked;

  const NotificationCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.content,
      this.isNew = false,
      this.isChecked = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (isNew) ? AppColor.markColor : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: SvgPicture.asset(
                "assets/images/notification_icon/$icon.svg",
                height: 24,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                  Text(
                    content,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ],
              ),
            ),
            if (isChecked)
              Container(
                width: 10, // 원의 너비
                height: 10, // 원의 높이
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, // 동그란 원을 그리도록 설정
                  color: AppColor.markColor, // 원의 색상 설정
                ),
              )
          ],
        ),
      ),
    );
  }
}
