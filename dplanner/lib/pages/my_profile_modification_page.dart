import 'package:cached_network_image/cached_network_image.dart';
import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/services/club_member_api_service.dart';
import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../controllers/size.dart';
import '../const/style.dart';
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

  XFile? file;

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

  Future<void> pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          file = image;
        });
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
            "프로필 편집하기",
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              ClipOval(
                                child: (file != null)
                                    ? Image.file(
                                        File(file!.path),
                                        height: SizeController.to.screenWidth *
                                            0.35,
                                        width: SizeController.to.screenWidth *
                                            0.35,
                                        fit: BoxFit.cover,
                                      )
                                    : MemberController.to.clubMember().url !=
                                            null
                                        ? CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Container(),
                                            imageUrl:
                                                "http://${MemberController.to.clubMember().url!}",
                                            errorWidget:
                                                (context, url, error) =>
                                                    SvgPicture.asset(
                                                      'assets/images/base_image/base_member_image.svg',
                                                    ),
                                            height:
                                                SizeController.to.screenWidth *
                                                    0.35,
                                            width:
                                                SizeController.to.screenWidth *
                                                    0.35,
                                            fit: BoxFit.cover)
                                        : SvgPicture.asset(
                                            'assets/images/base_image/base_member_image.svg',
                                            height:
                                                SizeController.to.screenWidth *
                                                    0.35,
                                            width:
                                                SizeController.to.screenWidth *
                                                    0.35,
                                            fit: BoxFit.cover,
                                          ),
                              ),
                              Positioned(
                                bottom: -5,
                                right: 0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    pickImage();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.subColor1,
                                      shape: const CircleBorder(),
                                      minimumSize: Size(
                                        SizeController.to.screenWidth * 0.08,
                                        SizeController.to.screenWidth * 0.08,
                                      )),
                                  child: const Icon(
                                    SFSymbols.pencil,
                                    color: AppColor.backgroundColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              "클럽 닉네임*",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                          Flexible(
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
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Form(
                          key: _formKey2,
                          child: OutlineTextForm(
                            hintText: '소개글을 작성해주세요',
                            controller: myContent,
                            isFocused: _isFocused2,
                            noLine: true,
                            fontSize: 16,
                            maxLines: 7,
                            onChanged: (value) {
                              setState(() {
                                _isFocused2 = value.isNotEmpty;
                              });
                            },
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
              child: Center(
                child: NextPageButton(
                  text: const Text(
                    "편집 완료하기",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.backgroundColor),
                  ),
                  buttonColor:
                      ((myName.text != MemberController.to.clubMember().name) ||
                              (myContent.text !=
                                  MemberController.to.clubMember().info) ||
                              (file != null))
                          ? AppColor.objectColor
                          : AppColor.subColor3,
                  onPressed: () async {
                    int clubMemberId = MemberController.to.clubMember().id;
                    int clubId = ClubController.to.club().id;
                    if ((myName.text ==
                            MemberController.to.clubMember().name) &&
                        (myContent.text ==
                            MemberController.to.clubMember().info) &&
                        (file == null)) {
                      return;
                    } else {
                      if (file != null) {
                        try {
                          MemberController.to.clubMember.value =
                              await ClubMemberApiService.postProfile(
                                  clubId: clubId,
                                  clubMemberId: clubMemberId,
                                  image: file);
                        } catch (e) {
                          print(e.toString());
                          snackBar(title: "프로필을 편집하지 못했습니다", content: "잠시 후 다시 시도해 주세요");
                        }
                      }
                      if ((myName.text !=
                              MemberController.to.clubMember().name) ||
                          (myContent.text !=
                              MemberController.to.clubMember().info)) {
                        try {
                          MemberController.to.clubMember.value =
                              await ClubMemberApiService.patchClubMember(
                                  clubMemberId: clubMemberId,
                                  clubId: clubId,
                                  name: myName.text,
                                  info: myContent.text);
                        } catch (e) {
                          print(e.toString());
                          snackBar(title: "프로필을 편집하지 못했습니다", content: "잠시 후 다시 시도해 주세요");
                        }
                      }
                      Get.offAllNamed('/tab3', arguments: 2);
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
