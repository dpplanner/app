import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';

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
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/images/club_create/club_invitecode.svg',
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
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
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/images/club_create/club_qrcode.svg',
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.objectColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Get.offAllNamed('/');
              },
              child: SizedBox(
                height: sizeController.screenHeight.value * 0.05,
                child: const Center(
                  child: Text(
                    '클럽 시작하기',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.backgroundColor),
                  ),
                ),
              ),
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
