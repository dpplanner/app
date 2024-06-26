import 'package:dplanner/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../const/style.dart';
import '../widgets/banner_ad_widget.dart';
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
  Map<String, String?> params = Get.parameters;

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
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("데이터를 불러오는데 실패했습니다."));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final alerts = snapshot.data!;
                return Column(
                  children: [
                    const BannerAdWidget(),
                    Column(
                      children: alerts
                          .map((alert) => NotificationCard(
                                id: alert.id,
                                type: alert.type,
                                title: alert.title,
                                content: alert.content,
                                isRead: alert.isRead,
                                redirectUrl: alert.redirectUrl,
                                infoType: alert.infoType,
                                info: alert.info,
                                isSelected: params.containsKey("id") && int.parse(params["id"]!) == alert.id
                              ))
                          .toList(),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text("알림이 없습니다."));
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
