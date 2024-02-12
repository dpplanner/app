import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/widgets/underline_textform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import '../widgets/nextpage_button.dart';
import '../widgets/outline_textform.dart';

class ClubJoinNextPage extends StatefulWidget {
  const ClubJoinNextPage({super.key});

  @override
  State<ClubJoinNextPage> createState() => _ClubJoinNextPageState();
}

class _ClubJoinNextPageState extends State<ClubJoinNextPage> {
  final clubController = Get.put((ClubController()));

  final _formKey1 = GlobalKey<FormState>();
  final TextEditingController myName = TextEditingController();
  bool _isFocused1 = false;

  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController myContent = TextEditingController();
  bool _isFocused2 = false;

  @override
  void dispose() {
    myName.dispose();
    myContent.dispose();
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
            "클럽 가입하기",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeController.to.screenHeight * 0.05),
              const Row(
                children: [
                  Text(
                    "클럽 ",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                  Text(
                    "Dance P.O.zz",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text(
                    " 에서",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                ],
              ),
              const Text(
                "사용하실 이름을 10글자 이내로 적어주세요",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
              SizedBox(height: SizeController.to.screenHeight * 0.01),
              Form(
                  key: _formKey1,
                  child: UnderlineTextForm(
                    hintText: '이름을 적어주세요',
                    controller: myName,
                    isFocused: _isFocused1,
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이름은 영어,한글,숫자,특수문자(,.!?)만 쓸 수 있어요';
                      } else if (!RegExp('[a-zA-Z가-힣,.!?\s]').hasMatch(value)) {
                        return '이름은 영어,한글,숫자,특수문자(,.!?)만 쓸 수 있어요';
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
              const Text(
                "자신을 소개하는 글도 적어주세요(선택)",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
              SizedBox(height: SizeController.to.screenHeight * 0.01),
              Form(
                  key: _formKey2,
                  child: OutlineTextForm(
                    hintText: '000자 내로 작성할 수 있어요\n언제든지 수정할 수 있으니 편하게 작성해주세요',
                    controller: myContent,
                    isFocused: _isFocused2,
                    maxLines: 5,
                    onChanged: (value) {
                      setState(() {
                        _isFocused2 = value.isNotEmpty;
                      });
                    },
                  )),
              const Expanded(child: SizedBox()),
              NextPageButton(
                text: const Text(
                  "가입 신청하기",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColor.backgroundColor),
                ),
                buttonColor: myName.text.isNotEmpty
                    ? AppColor.objectColor
                    : AppColor.subColor3,
                onPressed: () {
                  final formKeyState1 = _formKey1.currentState!;
                  if (formKeyState1.validate()) {
                    Get.offAllNamed('/club_join_success');
                  }
                },
              ),
              SizedBox(
                height: SizeController.to.screenHeight * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
