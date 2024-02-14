import 'package:dplanner/widgets/club_member_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import '../widgets/outline_textform.dart';

class ClubMemberListPage extends StatefulWidget {
  const ClubMemberListPage({super.key});

  @override
  State<ClubMemberListPage> createState() => _ClubMemberListPageState();
}

class _ClubMemberListPageState extends State<ClubMemberListPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searchPost = TextEditingController();
  bool _isFocused = false;

  @override
  void dispose() {
    searchPost.dispose();
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
            "회원 목록",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: AppColor.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
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
              const ClubMemberCard(
                name: "DP22 임동현",
                gradeName: "관리자",
              ),
              const ClubMemberCard(
                name: "DP22 정찬영",
                gradeName: "매니저",
              ),
              const ClubMemberCard(
                name: "DP23 강지인",
                gradeName: "매니저",
              ),
              const ClubMemberCard(
                name: "DP23 남진",
              ),
              const ClubMemberCard(
                name: "DP23 남진",
              ),
              const ClubMemberCard(
                name: "DP23 남진",
              ),
              const ClubMemberCard(
                name: "DP23 남진",
              ),
              const ClubMemberCard(
                name: "DP23 남진",
              ),
              const ClubMemberCard(
                name: "DP23 남진",
              ),
              const ClubMemberCard(
                name: "DP23 남진",
              ),
              const ClubMemberCard(
                name: "DP23 남진",
              ),
              const ClubMemberCard(
                name: "DP23 남진",
              ),
              const ClubMemberCard(
                name: "DP23 남진",
              ),
              const ClubMemberCard(
                name: "DP23 남진",
              ),
              const ClubMemberCard(
                name: "DP23 남진",
              ),
              const ClubMemberCard(
                name: "DP23 남진",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
