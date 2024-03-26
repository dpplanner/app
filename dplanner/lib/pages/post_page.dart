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
import 'package:dplanner/models/post_model.dart';
import 'package:dplanner/services/club_post_api_service.dart';

///
///
/// POST카드를 클릭하면 연결되는 POST 자세히보기 화면. 내용(글, 댓글)은 다른 class에서
///
///

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage({Key? key, required this.post}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addComment = TextEditingController();
  bool _isFocused = false;
  bool _isReplying = false; //답글을 다는 중인지 체크
  int? _replyingCommentId; //답글을 달려고 클릭한 댓글의 ID

  void startReplying(int commentId) {
    setState(() {
      _isReplying = true;
      _replyingCommentId = commentId;
    });
  }

  void _handleCommentSelected(int commentId) {
    setState(() {
      _replyingCommentId = commentId;
    });
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
              "게시글",
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
                    PostContent(post: widget.post),
                    Container(
                      color: AppColor.backgroundColor2,
                      height: SizeController.to.screenHeight * 0.01,
                    ),
                    PostComment(
                        post: widget.post,
                        onCommentSelected: _handleCommentSelected),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  ClipOval(
                    child: widget.post.profileUrl != null
                        ? Image.network(
                            widget.post.profileUrl!,
                            height: SizeController.to.screenWidth * 0.1,
                            width: SizeController.to.screenWidth * 0.1,
                            fit: BoxFit.cover,
                          )
                        : SvgPicture.asset(
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
                          onChanged: (value) {
                            setState(() {
                              _isFocused = value.isNotEmpty;
                            });
                          },
                          icon: GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                // 폼이 유효한 경우 댓글을 서버에 게시
                                print("==parentID: ${_replyingCommentId}");
                                await PostCommentApiService.postComment(
                                    postId: widget.post.id,
                                    content: addComment.text,
                                    parentId: _replyingCommentId);
                                // 댓글 입력 필드 초기화
                                addComment.clear();
                                _isReplying = false;
                                _replyingCommentId = null;
                              }
                            },
                            child: _isFocused
                                ? const Icon(
                                    SFSymbols.paperplane_fill,
                                    color: AppColor.objectColor,
                                  )
                                : const Icon(
                                    SFSymbols.paperplane,
                                    color: AppColor.textColor2,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
        bottomNavigationBar: const BottomBar());
  }
}
