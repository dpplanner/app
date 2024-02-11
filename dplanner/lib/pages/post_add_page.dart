import 'package:dplanner/widgets/image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import '../widgets/bottom_bar.dart';
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
              onPressed: () {},
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
                            child: Image.asset(
                              'assets/images/post_add_photo.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 18, 18),
                  child: const Text(
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
