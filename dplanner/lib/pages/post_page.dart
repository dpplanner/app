import 'package:dplanner/widgets/post_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/outline_textform.dart';
import '../widgets/post_content.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addComment = TextEditingController();
  bool _isFocused = false;

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
              "게시글",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            centerTitle: true,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const PostContent(),
              Container(
                color: AppColor.backgroundColor2,
                height: SizeController.to.screenHeight * 0.01,
              ),
              const Expanded(
                child: SingleChildScrollView(
                  child: PostComment(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children: [
                    ClipOval(
                      child: SvgPicture.asset(
                        'assets/images/base_image/base_member_image.svg',
                        height: SizeController.to.screenWidth * 0.1,
                        width: SizeController.to.screenWidth * 0.1,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                        child: Form(
                            key: _formKey,
                            child: OutlineTextForm(
                              hintText: '댓글을 남겨보세요',
                              controller: addComment,
                              isColored: true,
                              icon: _isFocused
                                  ? const Icon(
                                      SFSymbols.paperplane_fill,
                                      color: AppColor.objectColor,
                                    )
                                  : const Icon(
                                      SFSymbols.paperplane,
                                      color: AppColor.textColor2,
                                    ),
                              onChanged: (value) {
                                setState(() {
                                  _isFocused = value.isNotEmpty;
                                });
                              },
                            )),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: const BottomBar());
  }
}
