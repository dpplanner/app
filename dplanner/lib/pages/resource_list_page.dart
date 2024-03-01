import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/models/resource_model.dart';
import 'package:dplanner/services/resource_api_service.dart';
import 'package:dplanner/widgets/resource_card.dart';
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

  String selectedValue1 = type[0];
  String selectedValue2 = method[0];
  bool isChecked = false;

  @override
  void dispose() {
    name.dispose();
    info.dispose();
    notice.dispose();
    super.dispose();
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
                const Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                          child: Text(
                            "공간",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                        ResourceCard(name: "동아리 방"),
                        ResourceCard(name: "3층 연습실"),
                        ResourceCard(name: "풍물패"),
                        Padding(
                          padding: EdgeInsets.only(top: 32.0, bottom: 16.0),
                          child: Text(
                            "물건",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                        ResourceCard(name: "스피커-JBL"),
                        ResourceCard(name: "스피커-어쩌구"),
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
                        addResource();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ));
  }

  void addResource() {
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
                    const Text(
                      "공유 물품 추가하기",
                      style: TextStyle(
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
                                    controller: name,
                                    isFocused: isFocused1,
                                    noLine: true,
                                    isRight: true,
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
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 8.0),
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
                              Flexible(
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
                                        borderRadius: BorderRadius.circular(15),
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
                                        borderRadius: BorderRadius.circular(15),
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
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
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
                                    controller: info,
                                    isFocused: isFocused1,
                                    noLine: true,
                                    isRight: true,
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
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 24.0),
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
                              Flexible(
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
                                        borderRadius: BorderRadius.circular(15),
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
                                        borderRadius: BorderRadius.circular(15),
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
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          "주의사항",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Form(
                              key: formKey3,
                              child: OutlineTextForm(
                                hintText: '물품을 대여하는 사람에게 공지해야하는 내용을 작성해주세요',
                                fontSize: 15,
                                controller: notice,
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
              Padding(
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
                              resourceType:
                                  (selectedValue1 == "공간") ? "PLACE" : "THING");
                      Get.back();
                    } catch (e) {
                      print(e.toString());
                    }
                  },
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
}
