import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
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
          automaticallyImplyLeading: false,
          title: const Text(
            "클럽 가입하기",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: SizeController.to.screenHeight * 0.3),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "클럽",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
            Text(
              " Dance P.O.zz",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            )
          ]),
          const Text(
            "가입 신청이 완료되었어요!",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          ),
          SizedBox(height: SizeController.to.screenHeight * 0.005),
          const Text(
            "클럽 관리자의 승인을 기다리고 있어요",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          ),
          SizedBox(height: SizeController.to.screenHeight * 0.05),
          const Text(
            "push 알림 권한을 승인해주시면",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
          ),
          const Text(
            "가입 완료 알림을 바로 보내드릴 수 있어요",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
          ),
          SizedBox(height: SizeController.to.screenHeight * 0.005),
          NextPageButton(
            text: const Text(
              "알림 승인하기",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColor.backgroundColor),
            ),
            buttonColor: AppColor.objectColor,
            onPressed: () {
              Get.offNamed('/club_list');
            },
          ),
        ],
      ),
    );
  }
}
