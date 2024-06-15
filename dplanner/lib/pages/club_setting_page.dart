import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/widgets/mini_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/size.dart';
import '../services/club_api_service.dart';
import '../const/style.dart';
import '../widgets/nextpage_button.dart';
import '../widgets/outline_textform.dart';
import '../widgets/snack_bar.dart';
import 'error_page.dart';
import 'loading_page.dart';

class ClubSettingPage extends StatefulWidget {
  const ClubSettingPage({super.key});

  @override
  State<ClubSettingPage> createState() => _ClubSettingPageState();
}

class _ClubSettingPageState extends State<ClubSettingPage> {
  final _formKey1 = GlobalKey<FormState>();
  final TextEditingController info = TextEditingController();
  bool _isFocused1 = false;

  final StreamController<XFile> _streamController = StreamController<XFile>();

  XFile? file;

  @override
  void initState() {
    super.initState();
    info.text = ClubController.to.club().info;
  }

  @override
  void dispose() {
    info.dispose();
    _streamController.close();
    super.dispose();
  }

  void pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          file = image;
        });
        _streamController.add(file!);
      }
    } catch (e) {
      print('Error while picking an image: $e');
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
            "클럽 설정",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        StreamBuilder<Object>(
                            stream: _streamController.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const ErrorPage();
                              } else {
                                return Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: (file != null)
                                        ? Image.file(
                                            File(file!.path),
                                            height:
                                                SizeController.to.screenHeight *
                                                    0.28,
                                            width:
                                                SizeController.to.screenWidth,
                                            fit: BoxFit.fitWidth,
                                          )
                                        : ClubController.to.club().url != null
                                            ? CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    Container(),
                                                imageUrl:
                                                    "https://${ClubController.to.club().url}",
                                                errorWidget:
                                                    (context, url, error) =>
                                                        SvgPicture.asset(
                                                          'assets/images/base_image/base_club_big_image.svg',
                                                        ),
                                                height: SizeController
                                                        .to.screenHeight *
                                                    0.28,
                                                width: SizeController
                                                    .to.screenWidth,
                                                fit: BoxFit.fitWidth)
                                            : SvgPicture.asset(
                                                'assets/images/base_image/base_club_big_image.svg',
                                                height: SizeController
                                                        .to.screenHeight *
                                                    0.28,
                                                width: SizeController
                                                    .to.screenWidth,
                                                fit: BoxFit.fitWidth,
                                              ));
                              }
                            }),
                        Positioned(
                          bottom: 24,
                          right: 16,
                          child: MiniTextButton(
                            buttonColor: AppColor.subColor2,
                            onPressed: () {
                              pickImage();
                            },
                            text: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  SFSymbols.pencil,
                                  color: AppColor.textColor,
                                  size: 20,
                                ),
                                Text(
                                  "클럽 사진 수정하기",
                                  style: TextStyle(
                                      color: AppColor.textColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "클럽명",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: AppColor.textColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  ClubController.to.club().clubName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppColor.textColor),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12.0, top: 24.0),
                            child: Text(
                              "소개",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppColor.textColor),
                            ),
                          ),
                          Form(
                              key: _formKey1,
                              child: OutlineTextForm(
                                hintText: '소개글을 작성해주세요',
                                controller: info,
                                isFocused: _isFocused1,
                                fontSize: 15,
                                maxLines: 7,
                                onChanged: (value) {
                                  setState(() {
                                    _isFocused1 = value.isNotEmpty;
                                  });
                                },
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 40.0),
              child: Center(
                child: NextPageButton(
                  text: const Text(
                    "변경 사항 저장하기",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.backgroundColor),
                  ),
                  buttonColor: ((file != null) ||
                          (info.text != ClubController.to.club().info))
                      ? AppColor.objectColor
                      : AppColor.subColor3,
                  onPressed: () async {
                    int clubId = ClubController.to.club().id;
                    if ((file == null) &&
                        (info.text == ClubController.to.club().info)) {
                      return;
                    } else {
                      if (file != null) {
                        try {
                          ClubController.to.club.value =
                              await ClubApiService.postClubImage(
                                  clubId: clubId, image: file);
                        } catch (e) {
                          print(e.toString());
                          snackBar(
                              title: "프로필 편집하는데 오류가 발생하였습니다.",
                              content: e.toString());
                        }
                      }
                      if (info.text != ClubController.to.club().info) {
                        try {
                          ClubController.to.club.value =
                              await ClubApiService.patchClub(
                                  clubId: clubId, info: info.text);
                        } catch (e) {
                          print(e.toString());
                          snackBar(
                              title: "프로필 편집하는데 오류가 발생하였습니다.",
                              content: e.toString());
                        }
                      }
                      Get.back();
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
