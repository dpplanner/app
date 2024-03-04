import 'dart:async';

import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/controllers/member.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../models/club_member_model.dart';
import '../services/club_member_api_service.dart';
import '../style.dart';
import '../widgets/outline_textform.dart';
import 'error_page.dart';

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
              child: RefreshIndicator(
                onRefresh: getClubMemberList,
                child: LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          if (MemberController.to.clubMember().role == "ADMIN")
                            StreamBuilder<List<ClubMemberModel>>(
                                stream: streamController2.stream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<ClubMemberModel>>
                                        snapshot) {
                                  if (snapshot.hasData == false) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return const ErrorPage();
                                  } else {
                                    return Column(
                                      children: [
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Column(
                                              children: List.generate(
                                                  snapshot.data!.length,
                                                  (index) {
                                                return clubMemberCard(
                                                  member: snapshot.data![index],
                                                );
                                              }),
                                            )),
                                        Container(
                                          height:
                                              SizeController.to.screenHeight *
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
                                  AsyncSnapshot<List<ClubMemberModel>>
                                      snapshot) {
                                if (snapshot.hasData == false) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return const ErrorPage();
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
                      ));
                }),
              ),
            )
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
                            child: Image.asset(
                              'assets/images/jin_profile.png',
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
                              member.role,
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
                    IconButton(
                      onPressed: () {
                        _clubMemberInfo(member: member);
                      },
                      icon: const Icon(
                        SFSymbols.info_circle,
                        color: AppColor.textColor,
                        size: 20,
                      ),
                    ),
                    Visibility(
                      visible: member.isConfirmed,
                      replacement: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          SFSymbols.person_badge_plus,
                          color: AppColor.textColor,
                          size: 20,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {},
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

  void _clubMemberInfo({required ClubMemberModel member}) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColor.backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: SvgPicture.asset(
                    'assets/images/showmodal_scrollcontrolbar.svg',
                  ),
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "회원 정보",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/jin_profile.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 2,
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
                      flex: 3,
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
                            (member.role == "") ? "일반" : member.role,
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
              const Padding(
                padding: EdgeInsets.fromLTRB(32, 0, 32, 16),
                child: Expanded(
                  child: Text(
                    "안녕하세요 22기부회장 임동현입니다 감성코레오전문인데 어쩌구 저쩌구 이 앱 만든 장본인중 1나입니다 블라블라 룰루랄라",
                    style: TextStyle(
                      color: AppColor.textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
