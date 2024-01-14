import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import '../widgets/nextpage_button.dart';

class ClubCreatePage extends StatefulWidget {
  const ClubCreatePage({super.key});

  @override
  State<ClubCreatePage> createState() => _ClubCreatePageState();
}

class _ClubCreatePageState extends State<ClubCreatePage> {
  final sizeController = Get.put((SizeController()));
  final _formKey1 = GlobalKey<FormState>();
  bool _isFocused1 = false;

  final _formKey2 = GlobalKey<FormState>();
  bool _isFocused2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColor.backgroundColor,
          leadingWidth: sizeController.screenWidth.value * 0.2,
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
              SizedBox(height: sizeController.screenHeight.value * 0.05),
              const Row(
                children: [
                  Text(
                    "만들고 싶은 ",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                  Text(
                    "클럽의 이름",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text(
                    "을 적어주세요",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: sizeController.screenHeight.value * 0.01),

              ///TODO:텍스트 입력시 UI 변경하기
              Form(
                key: _formKey1,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: '클럽 이름을 적어주세요',
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColor.textColor2,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: _isFocused1
                              ? AppColor.objectColor
                              : AppColor.textColor2),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColor.markColor),
                    ),
                    contentPadding:
                        const EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 5.0),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColor.objectColor,
                  ),
                  validator: (value) {},
                  onSaved: (value) {},
                  onChanged: (value) {
                    setState(() {
                      _isFocused1 = value.isNotEmpty;
                    });
                  },
                ),
              ),
              SizedBox(height: sizeController.screenHeight.value * 0.1),
              const Row(
                children: [
                  Text(
                    "우리 클럽을 소개하는 ",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                  Text(
                    "소개글",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text(
                    "도 적어주세요",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: sizeController.screenHeight.value * 0.01),

              ///TODO:텍스트 입력시 UI 변경하기
              Form(
                key: _formKey2,
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    hintText:
                        '000자 내로 작성할 수 있어요\n관리자는 클럽 소개글을 언제든지 수정할 수 있으니\n편하게 작성해주세요',
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColor.textColor2,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: _isFocused2
                                ? AppColor.objectColor
                                : AppColor.textColor2),
                        borderRadius: BorderRadius.circular(15.0)),
                    errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColor.markColor),
                        borderRadius: BorderRadius.circular(15.0)),
                    contentPadding: const EdgeInsets.all(10.0),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColor.objectColor,
                  ),
                  validator: (value) {},
                  onSaved: (value) {},
                  onChanged: (value) {
                    setState(() {
                      _isFocused2 = value.isNotEmpty;
                    });
                  },
                ),
              ),
              const Expanded(child: SizedBox()),
              NextPageButton(
                name: '클럽 만들기',
                buttonColor: AppColor.objectColor,
                onPressed: () {
                  Get.offNamed('/club_create_success');
                },
              ),
              SizedBox(
                height: sizeController.screenHeight.value * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
