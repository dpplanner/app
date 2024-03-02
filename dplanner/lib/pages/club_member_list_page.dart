import 'dart:async';

import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/widgets/club_member_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
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

  @override
  void initState() {
    super.initState();
    getClubMemberList();
  }

  @override
  void dispose() {
    searchPost.dispose();
    streamController.close();
    super.dispose();
  }

  // 클럽 목록 불러오기
  Future<void> getClubMemberList() async {
    try {
      streamController.add(await ClubMemberApiService.getClubMemberList(
          clubId: ClubController.to.club().id));
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
                      child: StreamBuilder<List<ClubMemberModel>>(
                          stream: streamController.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ClubMemberModel>> snapshot) {
                            if (snapshot.hasData == false) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const ErrorPage();
                            } else if (snapshot.data!.isEmpty) {
                              return const SizedBox();
                            } else {
                              return Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        children: List.generate(
                                            snapshot.data!.length, (index) {
                                          return ClubMemberCard(
                                            member: snapshot.data![index],
                                          );
                                        }),
                                      )),
                                ],
                              );
                            }
                          }));
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
