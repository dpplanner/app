import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/services/club_member_api_service.dart';
import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import '../widgets/nextpage_button.dart';
import '../widgets/outline_textform.dart';
import '../widgets/underline_textform.dart';

class MyProfileModificationPage extends StatefulWidget {
  const MyProfileModificationPage({super.key});

  @override
  State<MyProfileModificationPage> createState() =>
      _MyProfileModificationPageState();
}

class _MyProfileModificationPageState extends State<MyProfileModificationPage> {
  final _formKey1 = GlobalKey<FormState>();
  final TextEditingController myName = TextEditingController();
  bool _isFocused1 = false;

  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController myContent = TextEditingController();
  bool _isFocused2 = false;

  @override
  void initState() {
    super.initState();
    myName.text = MemberController.to.clubMember().name;
    myContent.text = MemberController.to.clubMember().info ?? "";
  }

  @override
  void dispose() {
    myName.dispose();
    myContent.dispose();
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
            "프로필 편집하기",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(100),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/jin_profile.png',
                        height: SizeController.to.screenWidth * 0.25,
                        width: SizeController.to.screenWidth * 0.25,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      "클럽 닉네임*",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Form(
                        key: _formKey1,
                        child: UnderlineTextForm(
                          hintText: '닉네임을 작성해주세요',
                          controller: myName,
                          isFocused: _isFocused1,
                          noLine: true,
                          isRight: true,
                          fontSize: 16,
                          onChanged: (value) {
                            setState(() {
                              _isFocused1 = value.isNotEmpty;
                            });
                          },
                        )),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Text(
                "소개글",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                    key: _formKey2,
                    child: OutlineTextForm(
                      hintText: '소개글을 작성해주세요',
                      controller: myContent,
                      isFocused: _isFocused2,
                      noLine: true,
                      fontSize: 16,
                      maxLines: 30,
                      onChanged: (value) {
                        setState(() {
                          _isFocused2 = value.isNotEmpty;
                        });
                      },
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 48.0),
              child: Center(
                child: NextPageButton(
                  text: const Text(
                    "편집 완료하기",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.backgroundColor),
                  ),
                  buttonColor: AppColor.objectColor,
                  onPressed: () async {
                    try {
                      int clubMemberId = MemberController.to.clubMember().id;
                      MemberController.to.clubMember.value =
                          await ClubMemberApiService.patchClubMember(
                              clubMemberId: clubMemberId,
                              clubId: ClubController.to.club().id,
                              name: myName.text,
                              info: myContent.text);
                      Get.offAllNamed('/tab3', arguments: 2);
                    } catch (e) {
                      print(e.toString());
                      snackBar(
                          title: "프로필 편집하는데 오류가 발생하였습니다.",
                          content: e.toString());
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
