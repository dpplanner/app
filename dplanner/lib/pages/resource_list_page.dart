import 'dart:async';

import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/models/resource_model.dart';
import 'package:dplanner/services/resource_api_service.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import '../widgets/nextpage_button.dart';
import '../widgets/outline_textform.dart';
import '../widgets/underline_textform.dart';
import 'error_page.dart';

List<String> type = ['공간', '물품'];
List<String> method = ['예약 신청 후 클럽 관리자 승인'];

class ResourceListPage extends StatefulWidget {
  const ResourceListPage({super.key});

  @override
  State<ResourceListPage> createState() => _ResourceListPageState();
}

class _ResourceListPageState extends State<ResourceListPage> {
  final formKey1 = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  bool isFocused1 = false;

  final formKey2 = GlobalKey<FormState>();
  final TextEditingController info = TextEditingController();
  bool isFocused2 = false;

  final formKey3 = GlobalKey<FormState>();
  final TextEditingController notice = TextEditingController();
  bool isFocused3 = false;

  final TextEditingController updateName = TextEditingController();
  final TextEditingController updateInfo = TextEditingController();
  final TextEditingController updateNotice = TextEditingController();

  final StreamController<List<List<ResourceModel>>> _streamController =
      StreamController<List<List<ResourceModel>>>.broadcast();

  @override
  void dispose() {
    name.dispose();
    info.dispose();
    notice.dispose();
    updateName.dispose();
    updateInfo.dispose();
    updateNotice.dispose();
    _streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getResourceList();
  }

  void getResourceList() async {
    try {
      List<List<ResourceModel>> data = await ResourceApiService.getResources();
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
            leadingWidth: SizeController.to.screenWidth * 0.2,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(SFSymbols.chevron_left)),
            title: const Text(
              "공유 물품",
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                          child: Text(
                            "공간",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                        StreamBuilder(
                            stream: _streamController.stream,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData == false) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return const ErrorPage();
                              } else if (snapshot.data[0].length == 0) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    width: SizeController.to.screenWidth,
                                    child: const Text(
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
                                        snapshot.data[0].length, (index) {
                                  return resourceCard(
                                      resource: snapshot.data[0][index]);
                                }));
                              }
                            }),
                        const Padding(
                          padding: EdgeInsets.only(top: 32.0, bottom: 16.0),
                          child: Text(
                            "물건",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                        StreamBuilder(
                            stream: _streamController.stream,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData == false) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return const ErrorPage();
                              } else if (snapshot.data[1].length == 0) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SizedBox(
                                    width: SizeController.to.screenWidth,
                                    child: const Text(
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
                                        snapshot.data[1].length, (index) {
                                  return resourceCard(
                                      resource: snapshot.data[1][index]);
                                }));
                              }
                            }),
                      ],
                    ),
                  ),
                ),
                if (MemberController.to.clubMember().role == "ADMIN")
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: NextPageButton(
                      text: const Text(
                        "공유 물품 추가하기",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColor.backgroundColor),
                      ),
                      buttonColor: AppColor.objectColor,
                      onPressed: () {
                        addResource(
                            types: 0,
                            resource: ResourceModel(
                                id: 0,
                                name: "",
                                info: "",
                                returnMessageRequired: false,
                                resourceType: "",
                                notice: "",
                                clubId: 0));
                      },
                    ),
                  ),
              ],
            ),
          ),
        ));
  }

  //types: 0-물품 추가, 1-물품 정보, 2-물품 수정
  void addResource({required int types, required ResourceModel resource}) {
    String selectedValue1 =
        (resource.resourceType == "THING") ? type[1] : type[0];
    String selectedValue2 = method[0];
    bool isChecked = (resource.returnMessageRequired == true) ? true : false;

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
                          ? "공유 물품 추가하기"
                          : (types == 1)
                              ? "물품 정보"
                              : "공유 물품 수정하기",
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
                            const Padding(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                "이름",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Form(
                                  key: formKey1,
                                  child: UnderlineTextForm(
                                    hintText: '공유물품을 작성해주세요',
                                    controller:
                                        (types == 0) ? name : updateName,
                                    isFocused: isFocused1,
                                    noLine: true,
                                    isRight: true,
                                    isWritten: (types == 1) ? true : false,
                                    fontSize: 15,
                                    onChanged: (value) {
                                      setState(() {
                                        isFocused1 = value.isNotEmpty;
                                      });
                                    },
                                  )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: (types == 1)
                              ? const EdgeInsets.only(top: 28.0, bottom: 15.0)
                              : const EdgeInsets.only(top: 20.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                flex: 4,
                                child: Text(
                                  "유형",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: (types != 1),
                                replacement: Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                  child: Text(
                                    resource.resourceType == "PLACE"
                                        ? "공간"
                                        : "물건",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                child: Flexible(
                                  flex: 1,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      items: type
                                          .map((String item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            AppColor.textColor),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                      value: selectedValue1,
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedValue1 = value!;
                                        });
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 40,
                                        width: SizeController.to.screenWidth,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: AppColor.backgroundColor,
                                        ),
                                      ),
                                      iconStyleData: const IconStyleData(
                                          icon: Icon(
                                            SFSymbols.chevron_down,
                                          ),
                                          iconSize: 15,
                                          iconEnabledColor: AppColor.textColor),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: AppColor.backgroundColor,
                                        ),
                                        offset: const Offset(0, 45),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness:
                                              MaterialStateProperty.all<double>(
                                                  6),
                                          thumbVisibility:
                                              MaterialStateProperty.all<bool>(
                                                  true),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                "대여 위치",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Form(
                                  key: formKey2,
                                  child: UnderlineTextForm(
                                    hintText: '대여 위치를 작성해주세요',
                                    controller:
                                        (types == 0) ? info : updateInfo,
                                    isFocused: isFocused1,
                                    noLine: true,
                                    isRight: true,
                                    isWritten: (types == 1) ? true : false,
                                    fontSize: 15,
                                    onChanged: (value) {
                                      setState(() {
                                        isFocused2 = value.isNotEmpty;
                                      });
                                    },
                                  )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: (types == 1)
                              ? const EdgeInsets.only(top: 28.0, bottom: 24.0)
                              : const EdgeInsets.only(top: 20.0, bottom: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                flex: 1,
                                child: Text(
                                  "예약 방식",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: (types != 1),
                                replacement: Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                  child: Text(
                                    method[0],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                child: Flexible(
                                  flex: 2,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      items: method
                                          .map((String item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            AppColor.textColor),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                      value: selectedValue2,
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedValue2 = value!;
                                        });
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 40,
                                        width: SizeController.to.screenWidth,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: AppColor.backgroundColor,
                                        ),
                                      ),
                                      iconStyleData: const IconStyleData(
                                          icon: Icon(
                                            SFSymbols.chevron_down,
                                          ),
                                          iconSize: 15,
                                          iconEnabledColor: AppColor.textColor),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: AppColor.backgroundColor,
                                        ),
                                        offset: const Offset(0, 45),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness:
                                              MaterialStateProperty.all<double>(
                                                  6),
                                          thumbVisibility:
                                              MaterialStateProperty.all<bool>(
                                                  true),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (types != 1)
                          const Text(
                            "주의사항",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (types != 1)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Form(
                                key: formKey3,
                                child: OutlineTextForm(
                                  hintText: '물품을 대여하는 사람에게 공지해야하는 내용을 작성해주세요',
                                  fontSize: 15,
                                  controller:
                                      (types == 0) ? notice : updateNotice,
                                  isFocused: isFocused3,
                                  maxLines: 2,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '클럽 소개글을 작성해주세요';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      isFocused3 = value.isNotEmpty;
                                    });
                                  },
                                )),
                          ),
                        if (types != 1)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isChecked = !isChecked;
                                  });
                                },
                                icon: const Icon(SFSymbols.square),
                                selectedIcon: const Icon(
                                  SFSymbols.checkmark_square_fill,
                                  color: AppColor.objectColor,
                                ),
                                isSelected: isChecked ? true : false,
                              ),
                              const Text(
                                "반납 정보를 작성해야 하는 물품이면 체크하세요",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                ),
              ),
              if (MemberController.to.clubMember().role == "ADMIN")
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
                        try {
                          ResourceModel temp =
                              await ResourceApiService.postResource(
                                  clubId: ClubController.to.club().id,
                                  name: name.text,
                                  info: info.text,
                                  returnMessageRequired: isChecked,
                                  notice: notice.text,
                                  resourceType: (selectedValue1 == "공간")
                                      ? "PLACE"
                                      : "THING");
                          name.text = "";
                          info.text = "";
                          notice.text = "";
                          getResourceList();
                          Get.back();
                        } catch (e) {
                          print(e.toString());
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
                          try {
                            ResourceModel temp =
                                await ResourceApiService.putResource(
                                    id: resource.id,
                                    name: updateName.text,
                                    info: updateInfo.text,
                                    returnMessageRequired: isChecked,
                                    notice: updateNotice.text,
                                    resourceType: (selectedValue1 == "공간")
                                        ? "PLACE"
                                        : "THING");
                            getResourceList();
                            Get.back();
                          } catch (e) {
                            print(e.toString());
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

  void checkDeleteResource({required int id}) {
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
              "한번 삭제한 공유 물품은",
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
                      await ResourceApiService.deleteResource(resourceId: id);
                      getResourceList();
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

  Widget resourceCard({required ResourceModel resource}) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            resource.name,
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
                  updateName.text = resource.name;
                  updateInfo.text = resource.info;
                  updateNotice.text = resource.notice;
                  addResource(types: 1, resource: resource);
                },
                icon: const Icon(
                  SFSymbols.info_circle,
                  color: AppColor.textColor,
                  size: 20,
                ),
              ),
              if (MemberController.to.clubMember().role == "ADMIN")
                IconButton(
                  onPressed: () {
                    checkDeleteResource(id: resource.id);
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
