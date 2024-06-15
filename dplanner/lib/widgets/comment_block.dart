import 'package:cached_network_image/cached_network_image.dart';
import 'package:dplanner/models/post_comment_model.dart';
import 'package:dplanner/widgets/report_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/member.dart';
import '../controllers/size.dart';
import '../services/club_post_api_service.dart';
import '../style.dart';
import 'nextpage_button.dart';

class CommentBlock extends StatefulWidget {
  final bool isSelected;
  final Comment comment;
  final Function(int?) onCommentSelected;
  final void Function() onCommentDeleted;

  const CommentBlock(
      {Key? key,
        required this.isSelected,
        required this.comment,
        required this.onCommentSelected,
        required this.onCommentDeleted})
      : super(key: key);

  @override
  State<CommentBlock> createState() => _CommentBlockState();
}

class _CommentBlockState extends State<CommentBlock> {
  bool _showReplies = false;

  void _toggleShowReplies() {
    setState(() {
      _showReplies = !_showReplies;
    });
  }

  void _onReplyButtonTapped(int commentId) {
    int? selectedCommentId;

    // 선택된 상태에서 답글달기 다시 누르면 선택 해제
    if (!widget.isSelected) {
      selectedCommentId = commentId;
    }

    widget.onCommentSelected(selectedCommentId);
  }

  Future<void> _showReportDialog(BuildContext context, int commentId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ReportDialog(targetId: commentId, targetType: "COMMENT");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.isSelected ? AppColor.subColor2.withOpacity(0.3) : null,
      child: Padding(
        padding: widget.comment.parentId == null
            ? const EdgeInsets.fromLTRB(24, 12, 24, 12)   // 댓글일때
            : const EdgeInsets.fromLTRB(0, 12, 0, 12),    // 답글일때
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
                child: widget.comment.profileUrl != null && !widget.comment.isDeleted
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(),
                        imageUrl: widget.comment.profileUrl!,
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
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              !widget.comment.isDeleted
                              ? Text(
                                widget.comment.clubMemberName,
                                style: const TextStyle(
                                  color: AppColor.textColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              )
                              : const Text(
                                "(삭제)",
                                style: TextStyle(
                                  color: AppColor.textColor2,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: SizeController.to.screenWidth * 0.05,
                              ),
                            ],
                          ),
                          !widget.comment.isDeleted
                          ? Text(
                            widget.comment.content,
                            style: const TextStyle(
                              color: AppColor.textColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          )
                          : const Text(
                            "삭제된 댓글입니다.",
                            style: TextStyle(
                              color: AppColor.textColor2,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                DateFormat('M월 dd일')
                                    .add_jm()
                                    .format(widget.comment.createdTime),
                                style: const TextStyle(
                                  color: AppColor.textColor2,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                              if (widget.comment.parentId == null)
                                SizedBox(
                                  width: SizeController.to.screenWidth * 0.03,
                                ),
                              if (widget.comment.parentId == null)
                                InkWell(
                                  onTap: () {
                                    _onReplyButtonTapped(widget.comment.id); //답글이 달리는 댓글의 아이디
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
                      )),
                      IconButton(
                        onPressed: () {
                          _commentMore(context, widget.comment);
                        },
                        icon: const Icon(
                          SFSymbols.ellipsis,
                          color: AppColor.textColor,
                        ),
                      )
                    ],
                  ),
                  widget.comment.children.isNotEmpty
                      ? Column(
                          children: [
                            if (_showReplies) ...[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: widget.comment.children.map((child) {
                                  // 답글 블록 생성
                                  return CommentBlock(
                                    isSelected: false,
                                    comment: child,
                                    onCommentSelected: widget.onCommentSelected,
                                    onCommentDeleted: widget.onCommentDeleted,
                                  );
                                }).toList(),
                              ),
                            ],
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/extra/comment_line.svg',
                                ),
                                InkWell(
                                  onTap: _toggleShowReplies,
                                  borderRadius: BorderRadius.circular(5),
                                  child: Text(
                                    _showReplies
                                        ? "답글 숨기기"
                                        : "  답글 ${widget.comment.children.length}개 더 보기",
                                    style: const TextStyle(
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
        ),
      ),
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
                          widget.onCommentDeleted();
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
                          _showReportDialog(context, comment.id);
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
