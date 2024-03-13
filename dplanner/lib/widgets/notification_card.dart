import 'package:dplanner/style.dart';
import 'package:flutter/material.dart';
import 'package:dplanner/services/club_alert_api_service.dart';
import 'package:get/get.dart';

class NotificationCard extends StatelessWidget {
  // final String icon;
  final int ID;
  final String title;
  final String content;
  final bool isRead;
  final String redirectUrl;

  const NotificationCard({
    super.key,
    //     required this.icon,
    required this.ID,
    required this.title,
    required this.content,
    required this.isRead,
    required this.redirectUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await ClubAlertApiService.markAsRead(ID);

        // redirectUrl로 리다이렉트
        if (redirectUrl.isNotEmpty) {
          Get.toNamed(redirectUrl); // Getx 사용
        }
      },
      child: Container(
        color: (!isRead)
            ? AppColor.markColor.withOpacity(0.15)
            : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Padding(
              //  padding: const EdgeInsets.only(right: 12.0),
              //  child: SvgPicture.asset(
              //    "assets/images/notification_icon/$icon.svg",
              //    height: 24,
              //  ),
              //),
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
            ],
          ),
        ),
      ),
    );
  }
}
