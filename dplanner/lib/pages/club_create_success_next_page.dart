import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import '../widgets/image_button.dart';
import '../widgets/nextpage_button.dart';

class ClubCreateSuccessNext extends StatefulWidget {
  const ClubCreateSuccessNext({super.key});

  @override
  State<ClubCreateSuccessNext> createState() => _ClubCreateSuccessNextState();
}

class _ClubCreateSuccessNextState extends State<ClubCreateSuccessNext> {
  final sizeController = Get.put((SizeController()));

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
            "클럽 만들기",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(height: sizeController.screenHeight.value * 0.15),
            const Text(
              "이제 회원을 모집해볼까요?",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
            SizedBox(height: sizeController.screenHeight.value * 0.02),
            const Text(
              "초대 링크를 받은 사람은",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
            const Text(
              "클럽 가입 신청을 보낼 수 있어요",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
            SizedBox(
              height: sizeController.screenHeight.value * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ImageButton(
                        image: 'assets/images/club_create/club_invitecode.svg',
                        onTap: () {}),
                    SizedBox(
                      height: sizeController.screenHeight.value * 0.01,
                    ),
                    const Text(
                      "초대링크 복사하기",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ImageButton(
                        image: 'assets/images/club_create/club_qrcode.svg',
                        onTap: () {}),
                    SizedBox(
                      height: sizeController.screenHeight.value * 0.01,
                    ),
                    const Text(
                      "QR코드 저장하기",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            NextPageButton(
              name: '클럽 시작하기',
              buttonColor: AppColor.objectColor,
              onPressed: () {
                Get.offAllNamed('/');
              },
            ),
            SizedBox(
              height: sizeController.screenHeight.value * 0.03,
            ),
          ],
        ),
      ),
    );
  }
}
