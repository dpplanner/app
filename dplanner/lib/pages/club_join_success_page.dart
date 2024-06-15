import 'package:dplanner/controllers/club.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/style.dart';
import '../widgets/nextpage_button.dart';

class ClubJoinSuccessPage extends StatelessWidget {
  const ClubJoinSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColor.backgroundColor,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            "클럽 가입하기",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              "클럽 ",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
            Text(
              ClubController.to.club().clubName,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            )
          ]),
          const Text(
            "가입 신청이 완료되었어요!",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Text(
              "클럽 관리자의 승인을 기다리고 있어요",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
          ),
          const Text(
            "push 알림 권한을 승인해주시면",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
          ),
          const Text(
            "가입 완료 알림을 바로 보내드릴 수 있어요",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: NextPageButton(
              text: const Text(
                "알림 승인하기",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColor.backgroundColor),
              ),
              buttonColor: AppColor.objectColor,
              onPressed: () {
                Get.offAllNamed('/club_list');
              },
            ),
          ),
        ],
      ),
    );
  }
}
