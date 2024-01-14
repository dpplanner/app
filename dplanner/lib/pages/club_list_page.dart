import 'package:dplanner/style.dart';
import 'package:dplanner/widgets/club_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../controllers/size.dart';

class ClubListPage extends StatefulWidget {
  const ClubListPage({super.key});

  @override
  State<ClubListPage> createState() => _ClubListPageState();
}

class _ClubListPageState extends State<ClubListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor2,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColor.backgroundColor,
          leadingWidth: SizeController.to.screenWidth * 0.25,
          leading: SvgPicture.asset(
            'assets/images/dplanner_logo_mini.svg',
            fit: BoxFit.none,
          ),
          title: const Text(
            "클럽 목록",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: ClubCard(),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  ///TODO: 스플래시 컬러 지정
                  splashColor: AppColor.subColor2.withOpacity(0.8),
                  highlightColor: AppColor.subColor2.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {},
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColor.backgroundColor, // 원하는 색상으로 변경
                    ),
                    child: SizedBox(
                      width: SizeController.to.screenWidth,
                      height: SizeController.to.screenHeight * 0.15,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            SFSymbols.plus,
                            size: 35,
                            color: AppColor.objectColor,
                          ),
                          SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 5),
                              Text(
                                "새로운 클럽에 가입해보세요!",
                                style: TextStyle(
                                  color: AppColor.objectColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "내가 찾는 클럽이 없다면? ",
                    style: TextStyle(
                        color: AppColor.textColor2,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed('/club_create');
                    },
                    borderRadius: BorderRadius.circular(5),
                    child: const Text(
                      "클럽 만들기",
                      style: TextStyle(
                          color: AppColor.textColor2,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColor.textColor2,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
