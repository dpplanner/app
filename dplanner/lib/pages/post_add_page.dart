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

class PostAddPage extends StatefulWidget {
  const PostAddPage({super.key});

  @override
  State<PostAddPage> createState() => _PostAddPageState();
}

class _PostAddPageState extends State<PostAddPage> {
  final _formKey1 = GlobalKey<FormState>();
  final TextEditingController postSubject = TextEditingController();
  bool _isFocused1 = false;

  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController postContent = TextEditingController();
  bool _isFocused2 = false;

  Future<void> _submitPost() async {
    if (_formKey1.currentState!.validate() &&
        _formKey2.currentState!.validate()) {
      final url = Uri.parse('http://3.39.102.31:8080/posts');
      final headers = {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI1MDg1MyIsInJlY2VudF9jbHViX2lkIjoxLCJjbHViX21lbWJlcl9pZCI6MTA0MywiaXNzIjoiZHBsYW5uZXIiLCJpYXQiOjE3MDkzODQ1MjAsImV4cCI6MTcwOTU2NDUyMH0.aaQFRCYkHMA5k6Ot8rIEEdQKXivC5H0Th3O-TaArmWU',
      };
      final formData = http.MultipartRequest('POST', url);
      formData.headers.addAll(headers);
      final jsonData = {
        'clubId': 1,
        'title': postSubject.text,
        'content': postContent.text,
      };
      final jsonPart = http.MultipartFile.fromString(
        'create',
        jsonEncode(jsonData),
        contentType: MediaType('application', 'json'),
      );

      formData.files.add(jsonPart);

      try {
        final response = await formData.send();

        if (response.statusCode == 201) {
          // 요청이 성공한 경우
          Get.snackbar('알림', '게시글이 작성되었습니다.');
          // 페이지를 닫음
          Get.back();
        } else {
          // 요청이 실패한 경우
          //print('${response.body} ${response.statusCode}, ${body}');
          Get.snackbar('알림', '게시글 작성에 실패했습니다. error: ${response.statusCode}');
        }
      } catch (e) {
        // 요청 중 오류가 발생한 경우
        Get.snackbar('알림', '오류가 발생했습니다.');
      }
    }
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
          title: const Text(
            "글 쓰기",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: _submitPost,
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
                    hintText: '제목을 입력하세요',
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
                      hintText: '내용을 입력하세요',
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
