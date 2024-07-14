import 'dart:async';

import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../models/club_manager_model.dart';
import '../services/club_manager_api_service.dart';
import '../const/style.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/nextpage_button.dart';
import '../widgets/underline_textform.dart';
import 'error_page.dart';
import 'loading_page.dart';

class ClubManagerListPage extends StatefulWidget {
  const ClubManagerListPage({super.key});

  @override
  State<ClubManagerListPage> createState() => _ClubManagerListPageState();
}

class _ClubManagerListPageState extends State<ClubManagerListPage> {
  final formKey1 = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  bool isFocused1 = false;

  final TextEditingController updateName = TextEditingController();

  final StreamController<List<ClubManagerModel>> _streamController =
      StreamController<List<ClubManagerModel>>();

  @override
  void dispose() {
    name.dispose();
    updateName.dispose();
    _streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getClubManagerList();
  }

  Future<void> getClubManagerList() async {
    try {
      List<ClubManagerModel> data = await ClubManagerApiService.getClubManager(
          clubId: ClubController.to.club().id);
      _streamController.add(data);
    } catch (e) {
      print(e.toString());
    }
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
              "클럽 매니저 관리",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            centerTitle: true,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const BannerAdWidget(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                  child: Column(
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) => RefreshIndicator(
                              onRefresh: getClubManagerList,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: StreamBuilder(
                                    stream: _streamController.stream,
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.waiting ||
                                          snapshot.hasData == false) {
                                        return LoadingPage(constraints: constraints);
                                      } else if (snapshot.hasError) {
                                        return ErrorPage(constraints: constraints);
                                      } else if (snapshot.data.length == 0) {
                                        return SizedBox(
                                          width: SizeController.to.screenWidth,
                                          child: const Center(
                                            child: Text(
                                              "아직 아무것도 없어요",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                  color: AppColor.textColor2),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Column(
                                            children: List.generate(
                                                snapshot.data.length, (index) {
                                          return managerCard(
                                              manager: snapshot.data[index]);
                                        }));
                                      }
                                    }),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                        child: NextPageButton(
                          text: const Text(
                            "매니저 추가하기",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColor.backgroundColor),
                          ),
                          buttonColor: AppColor.objectColor,
                          onPressed: () {
                            addManager(
                                types: 0,
                                manager: ClubManagerModel(
                                    id: 0,
                                    clubId: ClubController.to.club().id,
                                    name: "",
                                    description: '',
                                    authorities: []));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  //types: 0-물품 추가, 1-물품 정보, 2-물품 수정
  void addManager({required int types, required ClubManagerModel manager}) {
    bool isChecked1 = manager.authorities.contains("SCHEDULE_ALL") ? true : false;
    bool isChecked2 = manager.authorities.contains("POST_ALL") ? true : false;
    bool isChecked3 = manager.authorities.contains("MEMBER_ALL") ? true : false;
    bool isChecked4 = manager.authorities.contains("RESOURCE_ALL") ? true : false;

    Get.bottomSheet(
      isScrollControlled: true,
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          height: SizeController.to.screenHeight * 0.7,
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                      child: SvgPicture.asset(
                        'assets/images/extra/showmodal_scrollcontrolbar.svg',
                      ),
                    ),
                    Text(
                      (types == 0)
                          ? "매니저 추가하기"
                          : (types == 1)
                              ? "매니저 정보"
                              : "매니저 수정하기",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 5.0),
                                child: Text(
                                  "매니저 이름",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Form(
                                  key: formKey1,
                                  child: UnderlineTextForm(
                                    hintText: '15글자 이내로 적어주세요',
                                    controller:
                                        (types == 0) ? name : updateName,
                                    isFocused: isFocused1,
                                    noLine: true,
                                    isRight: true,
                                    noErrorSign: true,
                                    isWritten: (types == 1) ? true : false,
                                    fontSize: 15,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        snackBar(
                                            title: "작성이 끝나지 않았습니다",
                                            content: "매니저 이름을 작성해주세요");
                                        return '';
                                      } else if (value.length > 15) {
                                        snackBar(
                                            title: "매니저 이름이 너무 깁니다",
                                            content: "15자 이내로 작성해주세요");
                                        return value;
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        isFocused1 = value.isNotEmpty;
                                      });
                                    },
                                  )),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                          child: Text(
                            "권한 설정",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (types == 1) {
                                  return;
                                }
                                setState(() {
                                  isChecked1 = !isChecked1;
                                });
                              },
                              icon: const Icon(SFSymbols.square),
                              selectedIcon: Icon(
                                SFSymbols.checkmark_square_fill,
                                color: types == 1 ? AppColor.subColor5 : AppColor.objectColor,
                              ),
                              isSelected: isChecked1 ? true : false,
                            ),
                            const Text(
                              "예약 관리 권한",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (types == 1) {
                                  return;
                                }
                                setState(() {
                                  isChecked2 = !isChecked2;
                                });
                              },
                              icon: const Icon(SFSymbols.square),
                              selectedIcon: Icon(
                                SFSymbols.checkmark_square_fill,
                                color: types == 1 ? AppColor.subColor5 : AppColor.objectColor,
                              ),
                              isSelected: isChecked2 ? true : false,
                            ),
                            const Text(
                              "게시글 관리 권한",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (types == 1) {
                                  return;
                                }
                                setState(() {
                                  isChecked3 = !isChecked3;
                                });
                              },
                              icon: const Icon(SFSymbols.square),
                              selectedIcon: Icon(
                                SFSymbols.checkmark_square_fill,
                                color: types == 1 ? AppColor.subColor5 : AppColor.objectColor,
                              ),
                              isSelected: isChecked3 ? true : false,
                            ),
                            const Text(
                              "멤버 관리 권한",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (types == 1) {
                                  return;
                                }
                                setState(() {
                                  isChecked4 = !isChecked4;
                                });
                              },
                              icon: const Icon(SFSymbols.square),
                              selectedIcon: Icon(
                                SFSymbols.checkmark_square_fill,
                                color: types == 1 ? AppColor.subColor5 : AppColor.objectColor,
                              ),
                              isSelected: isChecked4 ? true : false,
                            ),
                            const Text(
                              "공유 물품 관리 권한",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: types != 0,
                replacement: Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 40.0),
                  child: NextPageButton(
                    text: const Text(
                      "추가하기",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColor.backgroundColor),
                    ),
                    buttonColor: AppColor.objectColor,
                    onPressed: () async {
                      final formKeyState1 = formKey1.currentState!;
                      if (formKeyState1.validate()) {
                        try {
                          List<dynamic> authorities = [];
                          if (isChecked1) {
                            authorities.add("SCHEDULE_ALL");
                          }
                          if (isChecked2) {
                            authorities.add("POST_ALL");
                          }
                          if (isChecked3) {
                            authorities.add("MEMBER_ALL");
                          }
                          if (isChecked4) {
                            authorities.add("RESOURCE_ALL");
                          }
                          ClubManagerModel temp =
                              await ClubManagerApiService.postClubManager(
                                  clubId: ClubController.to.club().id,
                                  name: name.text,
                                  description: '',
                                  authorities: authorities);
                          name.text = "";
                          getClubManagerList();
                          Get.back();
                          snackBar(title: "매니저 권한이 추가되었습니다", content: "매니저 정보를 확인해 주세요");
                        } catch (e) {
                          print(e.toString());
                          snackBar(title: "매니저 권한을 추가하지 못했습니다", content: "잠시 후 다시 시도해 주세요");
                        }
                      }
                    },
                  ),
                ),
                child: Visibility(
                  visible: types == 2,
                  replacement: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 40.0),
                    child: NextPageButton(
                      text: const Text(
                        "수정하기",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColor.backgroundColor),
                      ),
                      buttonColor: AppColor.objectColor,
                      onPressed: () async {
                        setState(() {
                          types = 2;
                        });
                      },
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 40.0),
                    child: NextPageButton(
                      text: const Text(
                        "수정 완료하기",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColor.backgroundColor),
                      ),
                      buttonColor: AppColor.objectColor,
                      onPressed: () async {
                        final formKeyState1 = formKey1.currentState!;
                        if (formKeyState1.validate()) {
                          try {
                            List<dynamic> authorities = [];
                            if (isChecked1) {
                              authorities.add("SCHEDULE_ALL");
                            }
                            if (isChecked2) {
                              authorities.add("POST_ALL");
                            }
                            if (isChecked3) {
                              authorities.add("MEMBER_ALL");
                            }
                            if (isChecked4) {
                              authorities.add("RESOURCE_ALL");
                            }
                            ClubManagerModel temp =
                                await ClubManagerApiService.putClubManager(
                                    id: manager.id,
                                    clubId: manager.clubId,
                                    name: updateName.text,
                                    description: '',
                                    authorities: authorities);
                            getClubManagerList();
                            Get.back();
                            snackBar(title: "매니저 권한이 수정되었습니다", content: "매니저 정보를 확인해 주세요");
                          } catch (e) {
                            print(e.toString());
                            snackBar(title: "매니저 권한을 수정하지 못했습니다", content: "잠시 후 다시 시도해 주세요");
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      backgroundColor: AppColor.backgroundColor,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
    );
  }

  void checkDeleteManager({required int id}) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Center(
            child: Text(
              "매니저 삭제",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "한번 삭제한 매니저는",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Text(
              "되살릴 수 없습니다",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                "정말 삭제할까요?",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        actions: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: NextPageButton(
                  text: const Text(
                    "삭제하기",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.backgroundColor),
                  ),
                  buttonColor: AppColor.objectColor,
                  onPressed: () async {
                    try {
                      await ClubManagerApiService.deleteManager(
                          clubId: ClubController.to.club().id, id: id);
                      getClubManagerList();
                      Get.back();
                      snackBar(title: "매니저 권한을 삭제했습니다", content: "매니저 정보를 확인해 주세요");
                    } catch (e) {
                      print(e.toString());
                      snackBar(title: "매니저 권한을 삭제하지 못했습니다", content: "잠시 후 다시 시도해 주세요");
                    }
                  },
                ),
              ),
              TextButton(
                onPressed: Get.back,
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.transparent;
                      }
                      return Colors.transparent;
                    },
                  ),
                ),
                child: const Text(
                  "닫기",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textColor2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget managerCard({required ClubManagerModel manager}) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            manager.name,
            style: const TextStyle(
              color: AppColor.textColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  updateName.text = manager.name;
                  addManager(types: 1, manager: manager);
                },
                icon: const Icon(
                  SFSymbols.info_circle,
                  color: AppColor.textColor,
                  size: 20,
                ),
              ),
              IconButton(
                onPressed: () {
                  checkDeleteManager(id: manager.id);
                },
                icon: const Icon(
                  SFSymbols.trash,
                  color: AppColor.textColor,
                  size: 20,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
