import 'package:dplanner/pages/loading_page.dart';
import 'package:dplanner/widgets/post_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/posts.dart';
import '../controllers/size.dart';
import '../models/post_comment_model.dart';
import '../const/style.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/outline_textform.dart';
import '../widgets/post_content.dart';
import 'package:dplanner/services/club_post_api_service.dart';
import 'package:dplanner/controllers/member.dart';

///
///
/// POST카드를 클릭하면 연결되는 POST 자세히보기 화면. 내용(글, 댓글)은 다른 class에서
///
///

class PostPage extends StatefulWidget {
  final int postId;

  const PostPage({Key? key, required this.postId}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addComment = TextEditingController();
  bool _isFocused = false;
  bool _isReplying = false; //답글을 다는 중인지 체크
  int? _replyingCommentId; //답글을 달려고 클릭한 댓글의 ID
  List<Comment> _comments = [];

  // todo comment는 그대로, post는 Obx
  @override
  void initState() {
    super.initState();

    setState(() {
      _fetchComments();
    });
  }

  Future<void> _fetchPost() async {
    await PostController.to.fetchPost(widget.postId);
    setState(() {
      _fetchComments();
    });
  }

  Future<void> _fetchComments() async {
    final comments = await PostCommentApiService.fetchComments(widget.postId);
    if (comments != null) {
      setState(() {
        _comments = comments;
      });
    } else {
      setState(() {
        _comments = [];
      });
    }
  }

  void startReplying(int commentId) {
    setState(() {
      _isReplying = true;
      _replyingCommentId = commentId;
    });
  }

  void _handleCommentSelected(int? commentId) {
    setState(() {
      _replyingCommentId = commentId;
    });
  }

  void _handleCommentDeleted() async {
    await _fetchComments();
    await _fetchPost();
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: true,
          ),
        ),
        body: SafeArea(
            child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              return PostController.to.getRxPost(widget.postId) == null
                  ? const LoadingPage() // constraints 없어도 되나?
                  : Column(
                children: [
                  Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async { _fetchPost(); },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: Column(
                              children: [
                                Obx(() {
                                  return PostController.to.getRxPost(widget.postId) == null
                                      ? Container()
                                      : PostContent(post: PostController.to.getRxPost(widget.postId)!.value);
                                }),
                                Container(
                                  color: AppColor.backgroundColor2,
                                  height: SizeController.to.screenHeight * 0.01,
                                ),
                                PostComment(
                                    comments: _comments,
                                    selectedCommentId: _replyingCommentId,
                                    onCommentSelected: _handleCommentSelected,
                                    onCommentDeleted: _handleCommentDeleted
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        ClipOval(
                          child: MemberController.to.clubMember().url !=
                              null
                              ? CachedNetworkImage(
                              placeholder: (context, url) =>
                                  Container(),
                              imageUrl:
                              "http://${MemberController.to.clubMember().url!}",
                              errorWidget: (context, url, error) =>
                                  SvgPicture.asset(
                                    'assets/images/base_image/base_member_image.svg',
                                  ),
                              height:
                              SizeController.to.screenWidth * 0.1,
                              width:
                              SizeController.to.screenWidth * 0.1,
                              fit: BoxFit.cover)
                              : SvgPicture.asset(
                            'assets/images/base_image/base_member_image.svg',
                            height:
                            SizeController.to.screenWidth * 0.1,
                            width:
                            SizeController.to.screenWidth * 0.1,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                            child: Form(
                              key: _formKey,
                              child: OutlineTextForm(
                                hintText: _replyingCommentId == null
                                    ? '댓글을 남겨보세요'
                                    : "답글을 남겨보세요",
                                hintTextColor: _replyingCommentId == null
                                    ? AppColor.textColor2
                                    : AppColor.subColor1,
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
                                      await PostCommentApiService
                                          .postComment(
                                          postId: widget.postId,
                                          content: addComment.text,
                                          parentId: _replyingCommentId);
                                      // 댓글 입력 필드 초기화
                                      addComment.clear();
                                      _isReplying = false;
                                      _replyingCommentId = null;
                                      FocusScope.of(context).requestFocus(
                                          FocusNode()); //TODO: 체크해라 dismiss 되는지
                                    }
                                    _fetchPost(); // 댓글 단 후 게시글 새로고침
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
              );
            },)),
        bottomNavigationBar: const BottomBar());
  }
}
