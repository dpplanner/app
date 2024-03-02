import 'dart:async';
import 'dart:io';

import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/widgets/mini_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/size.dart';
import '../models/resource_model.dart';
import '../services/club_api_service.dart';
import '../services/resource_api_service.dart';
import '../style.dart';
import '../widgets/nextpage_button.dart';
import '../widgets/snack_bar.dart';
import 'error_page.dart';

class ClubSettingPage extends StatefulWidget {
  const ClubSettingPage({super.key});

  @override
  State<ClubSettingPage> createState() => _ClubSettingPageState();
}

class _ClubSettingPageState extends State<ClubSettingPage> {
  final StreamController<XFile> _streamController = StreamController<XFile>();

  XFile? file;

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
                                  padding: const EdgeInsets.only(
                                      top: 16.0, bottom: 24.0),
                                  child: (file != null)
                                      ? Image.file(
                                          File(file!.path),
                                          height:
                                              SizeController.to.screenHeight *
                                                  0.28,
                                          width: SizeController.to.screenWidth,
                                          fit: BoxFit.fitWidth,
                                        )
                                      : Visibility(
                                          visible:
                                              (ClubController.to.club().url ==
                                                  null),
                                          replacement: Image.network(
                                            "https://${ClubController.to.club().url}",
                                            height:
                                                SizeController.to.screenHeight *
                                                    0.28,
                                            width:
                                                SizeController.to.screenWidth,
                                            fit: BoxFit.fitWidth,
                                            errorBuilder: (BuildContext context,
                                                Object error,
                                                StackTrace? stackTrace) {
                                              return Container(
                                                color: AppColor.backgroundColor,
                                                height: SizeController
                                                        .to.screenHeight *
                                                    0.28,
                                                width: SizeController
                                                    .to.screenWidth,
                                                child: const Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Image',
                                                      style: TextStyle(
                                                        color:
                                                            AppColor.textColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Failed',
                                                      style: TextStyle(
                                                        color:
                                                            AppColor.textColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                          child: Image.asset(
                                            'assets/images/dancepozz_big_logo.png',
                                            height:
                                                SizeController.to.screenHeight *
                                                    0.28,
                                            width:
                                                SizeController.to.screenWidth,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                );
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
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      ClubController.to.club().clubName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 32),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                      child: Text(
                        ClubController.to.club().info,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
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
                  buttonColor: (file != null)
                      ? AppColor.objectColor
                      : AppColor.subColor3,
                  onPressed: () async {
                    if (file != null) {
                      try {
                        int clubId = ClubController.to.club().id;
                        ClubController.to.club.value =
                            await ClubApiService.postClubImage(
                                clubId: clubId, image: file);
                        Get.back();
                      } catch (e) {
                        print(e.toString());
                        snackBar(
                            title: "프로필 편집하는데 오류가 발생하였습니다.",
                            content: e.toString());
                      }
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
