import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/widgets/underline_textform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../services/club_api_service.dart';
import '../style.dart';
import '../widgets/nextpage_button.dart';
import '../widgets/outline_textform.dart';

class ClubCreatePage extends StatefulWidget {
  const ClubCreatePage({super.key});

  @override
  State<ClubCreatePage> createState() => _ClubCreatePageState();
}

class _ClubCreatePageState extends State<ClubCreatePage> {
  final _formKey1 = GlobalKey<FormState>();
  final TextEditingController clubName = TextEditingController();
  bool _isFocused1 = false;

  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController clubContent = TextEditingController();
  bool _isFocused2 = false;

  @override
  void dispose() {
    clubName.dispose();
    clubContent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            "클럽 만들기",
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
                    children: [
                      SizedBox(height: SizeController.to.screenHeight * 0.05),
                      const Row(
                        children: [
                          Text(
                            "만들고 싶은 ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18),
                          ),
                          Text(
                            "클럽의 이름",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          Text(
                            "을 적어주세요",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeController.to.screenHeight * 0.01),
                      Form(
                          key: _formKey1,
                          child: UnderlineTextForm(
                            hintText: '클럽 이름은 수정할 수 없으니 신중히 적어주세요',
                            fontSize: 15,
                            controller: clubName,
                            isFocused: _isFocused1,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '클럽 이름을 작성해주세요';
                              } else if (!RegExp('[a-zA-Z가-힣,.!?]')
                                  .hasMatch(value)) {
                                return '클럽 이름은 영어,한글,숫자,특수문자(,.!?)만 쓸 수 있어요';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _isFocused1 = value.isNotEmpty;
                              });
                            },
                          )),
                      SizedBox(height: SizeController.to.screenHeight * 0.1),
                      const Row(
                        children: [
                          Text(
                            "우리 클럽을 소개하는 ",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18),
                          ),
                          Text(
                            "소개글",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          Text(
                            "도 적어주세요",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeController.to.screenHeight * 0.01),
                      Form(
                          key: _formKey2,
                          child: OutlineTextForm(
                            hintText:
                                '000자 내로 작성할 수 있어요\n관리자는 클럽 소개글을 언제든지 수정할 수 있으니 편하게 작성해주세요',
                            fontSize: 15,
                            controller: clubContent,
                            isFocused: _isFocused2,
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '클럽 소개글을 작성해주세요';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _isFocused2 = value.isNotEmpty;
                              });
                            },
                          )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: NextPageButton(
                  text: const Text(
                    "클럽 만들기",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.backgroundColor),
                  ),
                  buttonColor: clubName.text.isNotEmpty
                      ? AppColor.objectColor
                      : AppColor.subColor3,
                  onPressed: () async {
                    final formKeyState1 = _formKey1.currentState!;
                    final formKeyState2 = _formKey2.currentState!;
                    if (formKeyState1.validate() && formKeyState2.validate()) {
                      try {
                        print(clubName.text);
                        print(clubContent.text);
                        ClubController.to.thisClub.value =
                            await ClubApiService.postClub(
                                clubName: clubName.text,
                                info: clubContent.text);
                        Get.offNamed('/club_create_success');
                      } catch (e) {
                        print(e.toString());
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
