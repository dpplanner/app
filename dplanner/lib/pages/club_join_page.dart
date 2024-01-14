import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/widgets/underline_textform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import '../widgets/club_card.dart';
import '../widgets/nextpage_button.dart';

class ClubJoinPage extends StatefulWidget {
  const ClubJoinPage({super.key});

  @override
  State<ClubJoinPage> createState() => _ClubJoinPagePageState();
}

class _ClubJoinPagePageState extends State<ClubJoinPage> {
  final clubController = Get.put((ClubController()));

  final _formKey = GlobalKey<FormState>();
  final TextEditingController clubInviteCode = TextEditingController();
  bool _isFocused = false;
  bool _isWritten = false;

  @override
  void dispose() {
    clubInviteCode.dispose();
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
              const Text(
                "가입할 클럽을 찾기 위해",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
              const Row(
                children: [
                  Text(
                    "클럽 초대코드",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text(
                    "를 입력해 주세요",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: SizeController.to.screenHeight * 0.01),
              Form(
                  key: _formKey,
                  child: UnderlineTextForm(
                    hintText: '초대코드 입력하기',
                    controller: clubInviteCode,
                    isFocused: _isFocused,
                    isWritten: _isWritten,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '클럽 초대코드를 정확히 입력해주세요';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _isFocused = value.isNotEmpty;
                      });
                    },
                  )),
              if (_isWritten)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: SizeController.to.screenHeight * 0.1),
                    const Text(
                      "찾으시는 클럽이 맞나요?",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                    ),
                    SizedBox(height: SizeController.to.screenHeight * 0.01),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.subColor1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const ClubCard(),
                    ),
                  ],
                ),
              const Expanded(child: SizedBox()),
              Visibility(
                visible: _isWritten,
                replacement: NextPageButton(
                  name: '입력 완료',
                  buttonColor: clubInviteCode.text.isNotEmpty
                      ? AppColor.objectColor
                      : AppColor.subColor3,
                  onPressed: () {
                    final formKeyState = _formKey.currentState!;
                    if (formKeyState.validate()) {
                      setState(() {
                        _isWritten = true;
                      });
                    }
                  },
                ),
                child: Column(
                  children: [
                    NextPageButton(
                      name: '네, 맞아요',
                      buttonColor: AppColor.objectColor,
                      onPressed: () {},
                    ),
                    SizedBox(height: SizeController.to.screenHeight * 0.005),
                    NextPageButton(
                      name: '아니오, 코드를 다시 입력할게요',
                      buttonColor: AppColor.subColor3,
                      onPressed: () {
                        setState(() {
                          _isWritten = false;
                        });
                      },
                    ),
                  ],
                ),
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
