import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/models/club_manager_model.dart';
import 'package:dplanner/services/club_api_service.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../models/club_member_model.dart';
import '../services/club_manager_api_service.dart';
import '../services/club_member_api_service.dart';
import '../style.dart';
import '../widgets/nextpage_button.dart';
import '../widgets/outline_textform.dart';
import 'error_page.dart';
import 'loading_page.dart';

class ClubMemberListPage extends StatefulWidget {
  const ClubMemberListPage({super.key});

  @override
  State<ClubMemberListPage> createState() => _ClubMemberListPageState();
}

class _ClubMemberListPageState extends State<ClubMemberListPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searchPost = TextEditingController();
  bool _isFocused = false;

  final StreamController<List<ClubMemberModel>> streamController =
      StreamController<List<ClubMemberModel>>();
  final StreamController<List<ClubMemberModel>> streamController2 =
      StreamController<List<ClubMemberModel>>();

  @override
  void initState() {
    super.initState();
    getClubMemberList();
  }

  @override
  void dispose() {
    searchPost.dispose();
    streamController.close();
    streamController2.close();
    super.dispose();
  }

  // 클럽 목록 불러오기
  Future<void> getClubMemberList() async {
    try {
      streamController.add(await ClubMemberApiService.getClubMemberList(
          clubId: ClubController.to.club().id, confirmed: true));
      streamController2.add(await ClubMemberApiService.getClubMemberList(
          clubId: ClubController.to.club().id, confirmed: false));
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
            "회원 목록",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColor.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 6, 24, 12),
                child: Form(
                    key: _formKey,
                    child: OutlineTextForm(
                      hintText: '클럽 회원 닉네임을 검색해보세요',
                      controller: searchPost,
                      isColored: true,
                      icon: Icon(
                        SFSymbols.search,
                        color: _isFocused
                            ? AppColor.objectColor
                            : AppColor.textColor2,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isFocused = value.isNotEmpty;
                        });
                      },
                    )),
              ),
            ),
            Flexible(
                child: LayoutBuilder(
              builder: (context, constraints) => RefreshIndicator(
                onRefresh: getClubMemberList,
                child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        if (MemberController.to.clubMember().role == "ADMIN" ||
                            (MemberController.to
                                        .clubMember()
                                        .clubAuthorityTypes !=
                                    null &&
                                MemberController.to
                                    .clubMember()
                                    .clubAuthorityTypes!
                                    .contains("Member_ALL")))
                          StreamBuilder<List<ClubMemberModel>>(
                              stream: streamController2.stream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<ClubMemberModel>>
                                      snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting ||
                                    snapshot.hasData == false) {
                                  return LoadingPage(constraints: constraints);
                                } else if (snapshot.hasError) {
                                  return ErrorPage(constraints: constraints);
                                } else if (snapshot.data!.isEmpty) {
                                  return const SizedBox();
                                } else {
                                  return Column(
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Column(
                                            children: List.generate(
                                                snapshot.data!.length, (index) {
                                              return clubMemberCard(
                                                member: snapshot.data![index],
                                              );
                                            }),
                                          )),
                                      Container(
                                        height: SizeController.to.screenHeight *
                                            0.005,
                                        color: AppColor.backgroundColor2,
                                      ),
                                    ],
                                  );
                                }
                              }),
                        StreamBuilder<List<ClubMemberModel>>(
                            stream: streamController.stream,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<ClubMemberModel>> snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  snapshot.hasData == false) {
                                return LoadingPage(constraints: constraints);
                              } else if (snapshot.hasError) {
                                return ErrorPage(constraints: constraints);
                              } else {
                                return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                      children: List.generate(
                                          snapshot.data!.length, (index) {
                                        return clubMemberCard(
                                          member: snapshot.data![index],
                                        );
                                      }),
                                    ));
                              }
                            }),
                      ],
                    )),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget clubMemberCard({required ClubMemberModel member}) {
    return Container(
      width: SizeController.to.screenWidth,
      color: AppColor.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 6, 24, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: ClipOval(
                            child: member.url != null
                                ? CachedNetworkImage(
                                    placeholder: (context, url) => Container(),
                                    imageUrl: "http://${member.url!}",
                                    errorWidget: (context, url, error) =>
                                        SvgPicture.asset(
                                          'assets/images/base_image/base_member_image.svg',
                                        ),
                                    height: SizeController.to.screenWidth * 0.1,
                                    width: SizeController.to.screenWidth * 0.1,
                                    fit: BoxFit.fill)
                                : SvgPicture.asset(
                                    'assets/images/base_image/base_member_image.svg',
                                    height: SizeController.to.screenWidth * 0.1,
                                    width: SizeController.to.screenWidth * 0.1,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Text(
                            member.name,
                            style: const TextStyle(
                              color: AppColor.textColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (!(member.role == "USER" && member.isConfirmed))
                          Visibility(
                            visible: member.isConfirmed,
                            replacement: Container(
                              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15),
                                color: AppColor.markColor, // 배경색 설정
                              ),
                              child: const Text(
                                "승인 대기중",
                                style: TextStyle(
                                  color: AppColor.backgroundColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15),
                                color: AppColor.subColor1, // 배경색 설정
                              ),
                              child: Text(
                                (member.role == "MANAGER")
                                    ? member.clubAuthorityName ?? ""
                                    : "관리자",
                                style: const TextStyle(
                                  color: AppColor.backgroundColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (member.isConfirmed)
                      IconButton(
                        onPressed: () {
                          _clubMemberInfo(types: 1, member: member);
                        },
                        icon: const Icon(
                          SFSymbols.info_circle,
                          color: AppColor.textColor,
                          size: 20,
                        ),
                      ),
                    if ((MemberController.to.clubMember().role == "ADMIN" ||
                            (MemberController.to
                                        .clubMember()
                                        .clubAuthorityTypes !=
                                    null &&
                                MemberController.to
                                    .clubMember()
                                    .clubAuthorityTypes!
                                    .contains("MEMBER_ALL"))) &&
                        member.role != "ADMIN" &&
                        member.id != MemberController.to.clubMember().id)
                      Visibility(
                        visible: member.isConfirmed,
                        replacement: IconButton(
                          onPressed: () async {
                            _clubMemberInfo(types: 0, member: member);
                          },
                          icon: const Icon(
                            SFSymbols.person_badge_plus,
                            color: AppColor.textColor,
                            size: 20,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            checkDeleteClubMember(member: member);
                          },
                          icon: const Icon(
                            SFSymbols.person_badge_minus,
                            color: AppColor.textColor,
                            size: 20,
                          ),
                        ),
                      )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //types: 0-승인 대기중, 1-회원 정보, 2-등급 수정
  Future<void> _clubMemberInfo(
      {required int types, required ClubMemberModel member}) async {
    List<String> grade = ['일반'];
    String selectedValue = grade[0];
    List<ClubManagerModel> managers = [];

    try {
      managers = await ClubManagerApiService.getClubManager(
          clubId: ClubController.to.club().id);
      for (var i in managers) {
        grade.insert(0, i.name);
      }
      selectedValue =
          (member.role == "MANAGER") ? member.clubAuthorityName ?? "" : "일반";
    } catch (e) {
      print(e.toString());
    }

    Get.bottomSheet(
      isScrollControlled: true,
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          height: SizeController.to.screenHeight * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          ? "승인 대기 중"
                          : (types == 1)
                              ? "회원 정보"
                              : "등급 수정",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Visibility(
                  visible: types != 2,
                  replacement: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: ClipOval(
                                child: Visibility(
                                  visible: (member.url == null),
                                  replacement: Image.network(
                                    "https://${member.url}",
                                    height:
                                        SizeController.to.screenWidth * 0.25,
                                    width: SizeController.to.screenWidth * 0.25,
                                    fit: BoxFit.fill,
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return Container(
                                        color: AppColor.backgroundColor,
                                        height: SizeController.to.screenWidth *
                                            0.25,
                                        width: SizeController.to.screenWidth *
                                            0.25,
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Image',
                                              style: TextStyle(
                                                color: AppColor.textColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              'Failed',
                                              style: TextStyle(
                                                color: AppColor.textColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/base_image/base_member_image.svg',
                                    height:
                                        SizeController.to.screenWidth * 0.25,
                                    width: SizeController.to.screenWidth * 0.25,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )),
                        ),
                        Row(
                          children: [
                            Text(
                              member.name,
                              style: const TextStyle(
                                color: AppColor.textColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              " 회원의 등급을",
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Row(
                            children: [
                              Text(
                                (member.role == "MANAGER")
                                    ? member.clubAuthorityName ?? ""
                                    : (member.role == "ADMIN")
                                        ? "관리자"
                                        : "일반",
                                style: const TextStyle(
                                  color: AppColor.textColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const Text(
                                "에서",
                                style: TextStyle(
                                  color: AppColor.textColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: SizeController.to.screenWidth * 0.3,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  items: grade
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
                                            value: item,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColor.textColor),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 40,
                                    width: SizeController.to.screenWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColor.subColor2,
                                    ),
                                  ),
                                  iconStyleData: const IconStyleData(
                                      icon: Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          SFSymbols.chevron_down,
                                        ),
                                      ),
                                      iconSize: 15,
                                      iconEnabledColor: AppColor.textColor),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColor.subColor2,
                                    ),
                                    offset: const Offset(0, 45),
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius: const Radius.circular(40),
                                      thickness:
                                          MaterialStateProperty.all<double>(6),
                                      thumbVisibility:
                                          MaterialStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              " 로 변경합니다",
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 24.0),
                              child: ClipOval(
                                child: Visibility(
                                  visible: (member.url == null),
                                  replacement: Image.network(
                                    "https://${member.url}",
                                    height:
                                        SizeController.to.screenWidth * 0.25,
                                    width: SizeController.to.screenWidth * 0.25,
                                    fit: BoxFit.fill,
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return Container(
                                        color: AppColor.backgroundColor,
                                        height: SizeController.to.screenWidth *
                                            0.25,
                                        width: SizeController.to.screenWidth *
                                            0.25,
                                        child: const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Image',
                                              style: TextStyle(
                                                color: AppColor.textColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              'Failed',
                                              style: TextStyle(
                                                color: AppColor.textColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/base_image/base_member_image.svg',
                                    height:
                                        SizeController.to.screenWidth * 0.25,
                                    width: SizeController.to.screenWidth * 0.25,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "클럽 닉네임",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "회원 등급",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.name,
                                    style: const TextStyle(
                                      color: AppColor.textColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    (member.role == "MANAGER")
                                        ? member.clubAuthorityName ?? ""
                                        : (member.role == "ADMIN")
                                            ? "관리자"
                                            : "일반",
                                    style: const TextStyle(
                                      color: AppColor.textColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(32, 32, 32, 16),
                        child: Text(
                          "소개글",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
                          child: Text(
                            member.info ?? "",
                            style: const TextStyle(
                              color: AppColor.textColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!(member.id == MemberController.to.clubMember().id ||
                  member.role == "ADMIN"))
                Visibility(
                  visible: types != 0,
                  replacement: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        NextPageButton(
                          text: const Text(
                            "가입 승인하기",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColor.backgroundColor),
                          ),
                          buttonColor: AppColor.objectColor,
                          onPressed: () async {
                            try {
                              await ClubMemberApiService.patchMemberToClub(
                                  clubMemberId: member.id,
                                  clubId: ClubController.to.club().id);
                              ClubController.to.club.value =
                                  await ClubApiService.getClub(
                                      clubID: ClubController.to.club().id);
                              getClubMemberList();
                              Get.back();
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0, top: 5),
                          child: NextPageButton(
                            text: const Text(
                              "가입 거절하기",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.backgroundColor),
                            ),
                            buttonColor: AppColor.markColor,
                            onPressed: () async {
                              try {
                                await ClubMemberApiService.deleteClubMember(
                                    clubMemberId: member.id,
                                    clubId: ClubController.to.club().id);
                                getClubMemberList();
                                ClubController.to.club.value =
                                    await ClubApiService.getClub(
                                        clubID: ClubController.to.club().id);
                                Get.back();
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: Visibility(
                    visible: types == 1,
                    replacement: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                      child: NextPageButton(
                        text: const Text(
                          "변경사항 반영하기",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColor.backgroundColor),
                        ),
                        buttonColor: AppColor.objectColor,
                        onPressed: () async {
                          String role = "";
                          int? clubAuthorityId;
                          if (selectedValue == "관리자") {
                            role = "ADMIN";
                          } else if (selectedValue == "일반") {
                            role = "USER";
                          } else {
                            role = "MANAGER";
                            for (var i in managers) {
                              if (i.name == selectedValue) {
                                clubAuthorityId = i.id;
                              }
                            }
                          }
                          try {
                            ClubMemberModel temp =
                                await ClubMemberApiService.patchAuthorities(
                                    clubMemberId: member.id,
                                    clubId: ClubController.to.club().id,
                                    role: role,
                                    clubAuthorityId: clubAuthorityId);
                            getClubMemberList();
                            Get.back();
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                      child: NextPageButton(
                        text: const Text(
                          "회원 등급 변경하기",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColor.backgroundColor),
                        ),
                        buttonColor: AppColor.objectColor,
                        onPressed: () {
                          setState(() {
                            types = 2;
                          });
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

  void checkDeleteClubMember({required ClubMemberModel member}) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "정말 이 회원을 ${ClubController.to.club().clubName}에서",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const Text(
                "퇴출하시나요?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "한번 퇴출된 회원은 재가입이 어려워요",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: ClipOval(
                      child: Visibility(
                        visible: (member.url == null),
                        replacement: Image.network(
                          "https://${member.url}",
                          height: SizeController.to.screenWidth * 0.1,
                          width: SizeController.to.screenWidth * 0.1,
                          fit: BoxFit.fill,
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return Container(
                              color: AppColor.backgroundColor,
                              height: SizeController.to.screenWidth * 0.1,
                              width: SizeController.to.screenWidth * 0.1,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Image',
                                    style: TextStyle(
                                      color: AppColor.textColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Failed',
                                    style: TextStyle(
                                      color: AppColor.textColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        child: SvgPicture.asset(
                          'assets/images/base_image/base_member_image.svg',
                          height: SizeController.to.screenWidth * 0.1,
                          width: SizeController.to.screenWidth * 0.1,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: const TextStyle(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        member.role,
                        style: const TextStyle(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: NextPageButton(
                    text: const Text(
                      "취소",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColor.backgroundColor),
                    ),
                    buttonColor: AppColor.objectColor,
                    onPressed: Get.back,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: NextPageButton(
                    text: const Text(
                      "퇴출하기",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColor.backgroundColor),
                    ),
                    buttonColor: AppColor.markColor,
                    onPressed: () async {
                      try {
                        await ClubMemberApiService.deleteClubMember(
                            clubMemberId: member.id,
                            clubId: ClubController.to.club().id);
                        getClubMemberList();
                        ClubController.to.club.value =
                            await ClubApiService.getClub(
                                clubID: ClubController.to.club().id);
                        Get.back();
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
