import 'package:dplanner/services/club_api_service.dart';
import 'package:dplanner/style.dart';
import 'package:dplanner/widgets/club_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../controllers/size.dart';
import '../models/club_model.dart';

class ClubListPage extends StatefulWidget {
  const ClubListPage({super.key});

  @override
  State<ClubListPage> createState() => _ClubListPageState();
}

class _ClubListPageState extends State<ClubListPage> {
  List<ClubModel> clubList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getClubList();
    });
  }

  // 클럽 목록 불러오기
  void getClubList() async {
    try {
      clubList = await ClubApiService.getClubList();
    } catch (e) {
      print(e.toString());
    }
  }

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
        child: ListView.builder(
            itemCount: clubList.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  if (index == 0)
                    const SizedBox(
                      height: 8,
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18.0, 12.0, 18.0, 0.0),
                    child: ClubCard(thisClub: clubList[index]),
                  ),
                  if (index == clubList.length - 1)
                    Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(18.0, 12.0, 18.0, 12.0),
                          child: InkWell(
                            ///TODO: 스플래시 컬러 지정
                            splashColor: AppColor.subColor2.withOpacity(0.5),
                            highlightColor: AppColor.subColor2.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Get.toNamed('/club_join');
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: AppColor.backgroundColor, // 원하는 색상으로 변경
                              ),
                              child: SizedBox(
                                width: SizeController.to.screenWidth,
                                height: SizeController.to.screenHeight * 0.13,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Row(
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
                        ),
                      ],
                    )
                ],
              );
            }),
      ),
    );
  }
}
