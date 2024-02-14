import 'package:dplanner/pages/club_member_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/nextpage_button.dart';

class ClubInfoPage extends StatefulWidget {
  const ClubInfoPage({super.key});

  @override
  State<ClubInfoPage> createState() => _ClubInfoPageState();
}

class _ClubInfoPageState extends State<ClubInfoPage> {
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
              "클럽 정보",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            centerTitle: true,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
                child: Image.asset(
                  'assets/images/dancepozz_big_logo.png',
                  height: SizeController.to.screenHeight * 0.28,
                  width: SizeController.to.screenWidth,
                  fit: BoxFit.fitWidth,
                ),
              ),
              const Text(
                "Dance P.O.zz",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 12, 24, 32),
                child: Text(
                  "중앙대학교 유일무일 스트릿댄스 동아리 Dance P.O.zz입 니다. 어저구저쩌구 룰루랄라 왁킹 짱 블라블라 어디까지 괜찮지?몇자가 적당하지?흠먄얌ㄴ랴먀",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 24.0),
                        child: Text(
                          "전체 회원",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            "133",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(const ClubMemberListPage());
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                SFSymbols.chevron_down,
                                color: AppColor.textColor,
                                size: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 24.0),
                        child: Text(
                          "게시글",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                      ),
                      Text(
                        "12",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 24.0),
                        child: Text(
                          "공유 물품",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            "1",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                          InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(16),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                SFSymbols.chevron_down,
                                color: AppColor.textColor,
                                size: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Center(
                  child: NextPageButton(
                    text: const Text(
                      "이 클럽 탈퇴하기",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColor.backgroundColor),
                    ),
                    buttonColor: AppColor.markColor,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomBar());
  }
}
