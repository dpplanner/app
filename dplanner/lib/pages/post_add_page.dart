import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

import '../controllers/size.dart';
import '../style.dart';
import '../widgets/outline_textform.dart';
import '../widgets/underline_textform.dart';
import 'package:dplanner/models/post_model.dart';
import 'package:dplanner/services/club_post_api_service.dart';

class PostAddPage extends StatefulWidget {
  final bool isEdit;
  final Post? post;
  final int clubID;
  const PostAddPage(
      {Key? key, this.isEdit = false, this.post, required this.clubID})
      : super(key: key);

  @override
  State<PostAddPage> createState() => _PostAddPageState();
}

class _PostAddPageState extends State<PostAddPage> {
  final _formKey1 = GlobalKey<FormState>();
  late TextEditingController postSubject = TextEditingController();
  bool _isFocused1 = false;

  final _formKey2 = GlobalKey<FormState>();
  late TextEditingController postContent = TextEditingController();
  bool _isFocused2 = false;

  @override
  void initState() {
    super.initState();
    // post가 null이 아닌 경우, 해당 post의 내용을 텍스트 필드에 채워넣기
    postSubject = TextEditingController(text: widget.post?.title ?? '');
    postContent = TextEditingController(text: widget.post?.content ?? '');
  }

  @override
  void dispose() {
    postSubject.dispose();
    postContent.dispose();
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
          scrolledUnderElevation: 0,
          leadingWidth: SizeController.to.screenWidth * 0.2,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(SFSymbols.chevron_left)),
          title: Text(
            widget.isEdit ? "글 수정" : "글 쓰기",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: widget.isEdit
                  ? () {
                      PostApiService.editPost(
                          postID: widget.post!.id,
                          title: postSubject.text,
                          content: postContent.text);
                    }
                  : () {
                      if (_formKey1.currentState!.validate() &&
                          _formKey2.currentState!.validate()) {
                        //TODO: 비어있지 않은 것 제대로 확인하도록 수정
                        PostApiService.submitPost(
                            clubId: widget.clubID,
                            title: postSubject.text,
                            content: postContent.text);
                      }
                    },
              child: const Text(
                "완료",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColor.markColor),
              ),
            ),
            SizedBox(width: SizeController.to.screenWidth * 0.03)
          ],
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Form(
                  key: _formKey1,
                  child: UnderlineTextForm(
                    hintText: widget.isEdit ? postSubject.text : '제목을 입력하세요',
                    controller: postSubject,
                    isFocused: _isFocused1,
                    noLine: true,
                    fontSize: 20,
                    onChanged: (value) {
                      setState(() {
                        _isFocused1 = value.isNotEmpty;
                      });
                    },
                  )),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Divider(
                color: AppColor.backgroundColor2,
                thickness: 2, // 줄의 색상 설정
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Form(
                    key: _formKey2,
                    child: OutlineTextForm(
                      hintText: widget.isEdit ? postContent.text : '내용을 입력하세요',
                      controller: postContent,
                      isFocused: _isFocused2,
                      noLine: true,
                      fontSize: 16,
                      maxLines: 20,
                      onChanged: (value) {
                        setState(() {
                          _isFocused2 = value.isNotEmpty;
                        });
                      },
                    )),
              ),
            ),
            const Divider(
              color: AppColor.backgroundColor2,
              thickness: 2, // 줄의 색상 설정
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 18),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(8),
                              child: SvgPicture.asset(
                                'assets/images/base_image/base_post_image.svg',
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 18, 18),
                  child: Text(
                    "2/10",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: AppColor.textColor2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
