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
import '../style.dart';
import '../widgets/nextpage_button.dart';
import '../widgets/underline_textform.dart';
import 'error_page.dart';

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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                      onRefresh: getClubManagerList,
                      child: LayoutBuilder(builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: StreamBuilder(
                              stream: _streamController.stream,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData == false) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return const ErrorPage();
                                } else if (snapshot.data.length == 0) {
                                  return SizedBox(
                                    width: SizeController.to.screenWidth,
                                    child: const Text(
                                      "아직 아무것도 없어요",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          color: AppColor.textColor2),
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
                        );
                      })),
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
        ));
  }

  //types: 0-물품 추가, 1-물품 정보, 2-물품 수정
  void addManager({required int types, required ClubManagerModel manager}) {
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
                        'assets/images/showmodal_scrollcontrolbar.svg',
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
                                    hintText: 'n글자 이내로 적어주세요',
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
                        const Text(
                          "권한 설정",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
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
                          // ClubManagerModel temp =
                          //     await ClubManagerApiService.postClubManager(
                          //         clubId: ClubController.to.club().id,
                          //         name: name.text,
                          //         info: info.text,
                          //         returnMessageRequired: isChecked,
                          //         notice: notice.text,
                          //         resourceType: (selectedValue1 == "공간")
                          //             ? "PLACE"
                          //             : "THING");
                          name.text = "";
                          getClubManagerList();
                          Get.back();
                        } catch (e) {
                          print(e.toString());
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
                            // ResourceModel temp =
                            //     await ResourceApiService.putResource(
                            //         id: resource.id,
                            //         name: updateName.text,
                            //         info: updateInfo.text,
                            //         returnMessageRequired: isChecked,
                            //         notice: updateNotice.text,
                            //         resourceType: (selectedValue1 == "공간")
                            //             ? "PLACE"
                            //             : "THING");
                            getClubManagerList();
                            Get.back();
                          } catch (e) {
                            print(e.toString());
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
              "물품 삭제",
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
                      //await ResourceApiService.deleteResource(resourceId: id);
                      getClubManagerList();
                      Get.back();
                    } catch (e) {
                      print(e.toString());
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
