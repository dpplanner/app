import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/member.dart';
import '../controllers/size.dart';
import '../style.dart';
import 'nextpage_button.dart';
import 'package:dplanner/models/post_model.dart';
import 'package:dplanner/models/post_comment_model.dart';
import 'package:dplanner/services/club_post_api_service.dart';

///
///
/// POST 자세히보기 화면에서 댓글 내용 그리는 class
///
///
class PostComment extends StatefulWidget {
  final Function(int) onCommentSelected;
  final Post post;
  const PostComment(
      {Key? key, required this.post, required this.onCommentSelected})
      : super(key: key);

  @override
  State<PostComment> createState() => _PostCommentState();
}

class _PostCommentState extends State<PostComment> {
  List<Comment>? _comments;
  bool showReplies = false;
  Map<int, bool>? showRepliesMap = {};

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  void _onReplyButtonTapped(int commentId) {
    widget.onCommentSelected(commentId);
  }

  Future<void> _fetchComments() async {
    final comments = await PostCommentApiService.fetchComments(widget.post.id);
    if (comments != null)
      setState(() {
        _comments = comments;
        showRepliesMap = Map.fromIterable(
          comments!.whereType<Comment>(), // Filter out null values if any
          key: (comment) => (comment as Comment).id,
          value: (_) => false,
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeController.to.screenWidth,
      color: AppColor.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _comments == null
              ? [
                  const Center(
                    child: Text(
                      "댓글이 없습니다",
                    ),
                  ),
                ]
              : [
                  // 댓글 데이터를 화면에 표시하는 부분
                  for (var comment in _comments!) commentBlock(comment),
                ],
        ),
      ),
    );
  }

  Widget commentBlock(Comment comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
            child: comment.profileUrl != null
                ? CachedNetworkImage(
                    placeholder: (context, url) => Container(),
                    imageUrl: comment.profileUrl!,
                    errorWidget: (context, url, error) => SvgPicture.asset(
                          'assets/images/base_image/base_member_image.svg',
                        ),
                    height: SizeController.to.screenWidth * 0.09,
                    width: SizeController.to.screenWidth * 0.09,
                    fit: BoxFit.fitHeight)
                : SvgPicture.asset(
                    'assets/images/base_image/base_member_image.svg',
                    height: SizeController.to.screenWidth * 0.09,
                    width: SizeController.to.screenWidth * 0.09,
                    fit: BoxFit.fill,
                  )),
        SizedBox(width: SizeController.to.screenWidth * 0.03),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            comment.clubMemberName,
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            width: SizeController.to.screenWidth * 0.05,
                          ),
                        ],
                      ),
                      Text(
                        comment.content,
                        style: TextStyle(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            DateFormat('M월 dd일')
                                .add_jm()
                                .format(comment.createdTime),
                            style: TextStyle(
                              color: AppColor.textColor2,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          if (comment.parentId == null)
                            SizedBox(
                              width: SizeController.to.screenWidth * 0.03,
                            ),
                          if (comment.parentId == null)
                            InkWell(
                              onTap: () {
                                _onReplyButtonTapped(
                                    comment.id); //답글이 달리는 댓글의 아이디
                              },
                              borderRadius: BorderRadius.circular(5),
                              child: const Text(
                                "답글 달기",
                                style: TextStyle(
                                  color: AppColor.textColor2,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      _commentMore(context, comment);
                    },
                    icon: const Icon(
                      SFSymbols.ellipsis,
                      color: AppColor.textColor,
                    ),
                  )
                ],
              ),
              comment.children.isNotEmpty
                  ? Column(
                      children: [
                        if (showRepliesMap?[comment.id] ?? false) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: comment.children.map((child) {
                              // 답글 블록 생성
                              return commentBlock(child);
                            }).toList(),
                          ),
                        ],
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/extra/comment_line.svg',
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (showRepliesMap != null) {
                                    showRepliesMap![comment.id] =
                                        !(showRepliesMap![comment.id] ?? false);
                                  }
                                });
                              },
                              borderRadius: BorderRadius.circular(5),
                              child: Text(
                                (showRepliesMap?[comment.id] ?? false)
                                    ? "답글 숨기기"
                                    : "  답글 ${comment.children.length}개 더 보기",
                                style: TextStyle(
                                  color: AppColor.textColor2,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  void _commentMore(BuildContext context, Comment comment) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: SizeController.to.screenHeight * 0.3,
          decoration: const BoxDecoration(
            color: AppColor.backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: SvgPicture.asset(
                  'assets/images/extra/showmodal_scrollcontrolbar.svg',
                ),
              ),
              if (comment.clubMemberId == MemberController.to.clubMember().id)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: NextPageButton(
                    buttonColor: AppColor.backgroundColor2,
                    text: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          SFSymbols.pencil_outline,
                          color: AppColor.textColor,
                        ),
                        Text(
                          " 수정하기",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColor.textColor),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              comment.clubMemberId == MemberController.to.clubMember().id ||
                      MemberController.to.clubMember().role == "ADMIN" ||
                      (MemberController.to.clubMember().clubAuthorityTypes !=
                              null &&
                          MemberController.to
                              .clubMember()
                              .clubAuthorityTypes!
                              .contains("POST_ALL"))
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                      child: NextPageButton(
                        buttonColor: AppColor.backgroundColor2,
                        text: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              SFSymbols.trash,
                              color: AppColor.markColor,
                            ),
                            Text(
                              " 삭제하기",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.markColor),
                            ),
                          ],
                        ),
                        onPressed: () {
                          PostCommentApiService.deleteComment(comment.id);
                          Get.back();
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: NextPageButton(
                        buttonColor: AppColor.backgroundColor2,
                        text: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              SFSymbols.exclamationmark_octagon,
                              color: AppColor.markColor,
                            ),
                            Text(
                              " 이 댓글 신고하기",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.markColor),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
