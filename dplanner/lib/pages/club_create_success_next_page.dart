import 'package:dplanner/controllers/club.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../services/club_api_service.dart';
import '../style.dart';
import '../widgets/image_button.dart';
import '../widgets/nextpage_button.dart';

class ClubCreateSuccessNextPage extends StatefulWidget {
  const ClubCreateSuccessNextPage({super.key});

  @override
  State<ClubCreateSuccessNextPage> createState() =>
      _ClubCreateSuccessNextPageState();
}

class _ClubCreateSuccessNextPageState extends State<ClubCreateSuccessNextPage> {
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
            SizedBox(height: SizeController.to.screenHeight * 0.15),
            const Text(
              "이제 회원을 모집해볼까요?",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            SizedBox(height: SizeController.to.screenHeight * 0.02),
            const Text(
              "초대 링크를 받은 사람은",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            const Text(
              "클럽 가입 신청을 보낼 수 있어요",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            SizedBox(
              height: SizeController.to.screenHeight * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            Clipboard.setData(ClipboardData(
                                text: await ClubApiService.postClubCode(
                                    clubId: ClubController.to.club().id)));
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.subColor4,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.all(30.0),
                          child: const Icon(SFSymbols.link,
                              color: AppColor.textColor),
                        ),
                      ),
                    ),
                    const Text(
                      "초대링크 복사하기",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.subColor4,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.all(30.0),
                          child: const Icon(SFSymbols.qrcode,
                              color: AppColor.textColor),
                        ),
                      ),
                    ),
                    const Text(
                      "QR코드 저장하기",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            NextPageButton(
              text: const Text(
                "클럽 시작하기",
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
            SizedBox(
              height: SizeController.to.screenHeight * 0.03,
            ),
          ],
        ),
      ),
    );
  }
}
