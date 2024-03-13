import 'package:dplanner/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import '../widgets/bottom_bar.dart';
import 'package:dplanner/services/club_alert_api_service.dart';
import 'package:dplanner/models/club_alert_message_model.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Future<List<AlertMessageModel>>? alertListFuture;

  @override
  void initState() {
    super.initState();
    alertListFuture = ClubAlertApiService.fetchAlertList(); // 알림 목록 불러오기
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<List<AlertMessageModel>>(
            future: alertListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("데이터를 불러오는데 실패했습니다."));
              } else if (snapshot.hasData) {
                final alerts = snapshot.data!;
                return Column(
                  children: alerts
                      .map((alert) => NotificationCard(
                            ID: alert.id,
                            isRead: alert.isRead,
                            // icon: alert.icon,
                            title: alert.title,
                            content: alert.content,
                            redirectUrl: alert.redirectUrl,
                          ))
                      .toList(),
                );
              } else {
                return Center(child: Text("알림이 없습니다."));
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
