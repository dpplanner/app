import 'package:dplanner/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import '../widgets/bottom_bar.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColor.backgroundColor,
          leadingWidth: SizeController.to.screenWidth * 0.2,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(SFSymbols.chevron_left)),
          title: const Text(
            "알림",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              NotificationCard(
                  isNew: true,
                  icon: "icon_accept",
                  title: "예약 신청이 승인되었어요",
                  content: "동아리 방의 12월 29일 17:00 ~ 19:00시 예약 신청을 관리자가 승인했어요"),
              NotificationCard(
                  isNew: true,
                  icon: "icon_reject",
                  title: "예약 신청이 거절되었어요",
                  content: "동아리 방의 12월 29일 17:00 ~ 19:00시 예약 신청을 관리자가 거절했어요"),
              NotificationCard(
                  isNew: true,
                  icon: "icon_invite",
                  title: "예약에 초대되었어요",
                  content:
                      "DP23 강지인 님의 12월 29일 17:00 ~ 19:00 동아리 방 예약에 초대되었어요"),
              NotificationCard(
                  isChecked: true,
                  icon: "icon_request",
                  title: "새로운 예약 요청이 있어요",
                  content:
                      "DP23 강지인 님의 12월 29일 17:00 ~ 19:00 동아리 방 예약 요청이 있어요"),
              NotificationCard(
                  icon: "icon_request",
                  title: "새로운 가입 요청이 있어요",
                  content: "DP23 강지인 님의 클럽 가입 요청이 있어요"),
              NotificationCard(
                  icon: "icon_report",
                  title: "신고된 게시글을 검토해주세요",
                  content: "12월 25일 19:12분에 작성된 게시글에 신고가 들어왔어요"),
              NotificationCard(
                  icon: "icon_notice",
                  title: "새로운 공지가 있어요",
                  content: "클럽 소식을 확인해주세요"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
