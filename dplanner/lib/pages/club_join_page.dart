import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/services/club_api_service.dart';
import 'package:dplanner/widgets/underline_textform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../models/club_model.dart';
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

  late ClubModel findClub;
  bool noClub = false;

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
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: SizeController.to.screenHeight * 0.05),
                      const Text(
                        "가입할 클럽을 찾기 위해",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                      const Row(
                        children: [
                          Text(
                            "클럽 초대코드",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          Text(
                            "를 입력해 주세요",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18),
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
                        Visibility(
                          visible: noClub,
                          replacement: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: SizeController.to.screenHeight * 0.1),
                              const Text(
                                "찾으시는 클럽이 맞나요?",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 18),
                              ),
                              SizedBox(
                                  height:
                                      SizeController.to.screenHeight * 0.01),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.subColor1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child:
                                    ClubCard(thisClub: findClub, noEvent: true),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                  height: SizeController.to.screenHeight * 0.1),
                              const Text(
                                "찾으시는 클럽이 없습니다",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 18),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Visibility(
                  visible: _isWritten,
                  replacement: NextPageButton(
                    text: const Text(
                      "입력 완료",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColor.backgroundColor),
                    ),
                    buttonColor: clubInviteCode.text.isNotEmpty
                        ? AppColor.objectColor
                        : AppColor.subColor3,
                    onPressed: () async {
                      final formKeyState = _formKey.currentState!;
                      if (formKeyState.validate()) {
                        try {
                          int clubCode = await ClubApiService.getJoinClub(
                              clubCode: clubInviteCode.text);
                          ClubModel tempClub =
                              await ClubApiService.getClub(clubID: clubCode);
                          setState(() {
                            findClub = tempClub;
                          });
                        } catch (e) {
                          print(e.toString());
                          setState(() {
                            noClub = true;
                          });
                        }
                        setState(() {
                          _isWritten = true;
                        });
                      }
                    },
                  ),
                  child: Visibility(
                    visible: noClub,
                    replacement: Column(
                      children: [
                        NextPageButton(
                          text: const Text(
                            "네, 맞아요",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColor.backgroundColor),
                          ),
                          buttonColor: AppColor.objectColor,
                          onPressed: () {
                            Get.toNamed('/club_join_next');
                          },
                        ),
                        SizedBox(
                            height: SizeController.to.screenHeight * 0.005),
                        NextPageButton(
                          text: const Text(
                            "아니오, 코드를 다시 입력할게요",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColor.backgroundColor),
                          ),
                          buttonColor: AppColor.subColor3,
                          onPressed: () {
                            setState(() {
                              _isWritten = false;
                            });
                          },
                        ),
                      ],
                    ),
                    child: NextPageButton(
                      text: const Text(
                        "코드를 다시 입력할게요",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColor.backgroundColor),
                      ),
                      buttonColor: AppColor.subColor3,
                      onPressed: () {
                        setState(() {
                          _isWritten = false;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
