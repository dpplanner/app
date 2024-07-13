import 'package:cached_network_image/cached_network_image.dart';
import 'package:dplanner/models/post_comment_model.dart';
import 'package:dplanner/widgets/report_dialog.dart';
import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/club.dart';
import '../controllers/member.dart';
import '../controllers/size.dart';
import '../models/club_member_model.dart';
import '../services/club_member_api_service.dart';
import '../services/club_post_api_service.dart';
import '../const/style.dart';
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
            ? const EdgeInsets.fromLTRB(24, 12, 24, 12) // 댓글일때
            : const EdgeInsets.fromLTRB(0, 12, 0, 12), // 답글일때
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                await _clubMemberInfo(memberId: widget.comment.clubMemberId);
              },
              child: ClipOval(
                  child: widget.comment.profileUrl != null &&
                          !widget.comment.isDeleted
                      ? CachedNetworkImage(
                          placeholder: (context, url) => Container(),
                          imageUrl: widget.comment.profileUrl!,
                          errorWidget: (context, url, error) =>
                              SvgPicture.asset(
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
            ),
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
                                  ? GestureDetector(
                                      onTap: () async {
                                        await _clubMemberInfo(
                                            memberId:
                                                widget.comment.clubMemberId);
                                      },
                                      child: Text(
                                        widget.comment.clubMemberName,
                                        style: const TextStyle(
                                          color: AppColor.textColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
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
                                    _onReplyButtonTapped(
                                        widget.comment.id); //답글이 달리는 댓글의 아이디
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

  Future<void> _clubMemberInfo({required int memberId}) async {
    ClubMemberModel member = ClubMemberModel(
        id: 0, name: "error", role: "MANAGER", isConfirmed: true);

    try {
      member = await ClubMemberApiService.getClubMember(
          clubId: ClubController.to.club.value.id, clubMemberId: memberId);
    } catch (e) {
      print(e.toString());
    }

    Get.bottomSheet(
      isScrollControlled: true,
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          height: SizeController.to.screenHeight * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                      child: SvgPicture.asset(
                        'assets/images/extra/showmodal_scrollcontrolbar.svg',
                      ),
                    ),
                    const Text(
                      "회원 정보",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 24.0),
                            child: ClipOval(
                              child: Visibility(
                                visible: (member.url == null),
                                replacement: Image.network(
                                  "https://${member.url}",
                                  height: SizeController.to.screenWidth * 0.25,
                                  width: SizeController.to.screenWidth * 0.25,
                                  fit: BoxFit.fill,
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return Container(
                                      color: AppColor.backgroundColor,
                                      height:
                                          SizeController.to.screenWidth * 0.25,
                                      width:
                                          SizeController.to.screenWidth * 0.25,
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Image',
                                            style: TextStyle(
                                              color: AppColor.textColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            'Failed',
                                            style: TextStyle(
                                              color: AppColor.textColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                child: SvgPicture.asset(
                                  'assets/images/base_image/base_member_image.svg',
                                  height: SizeController.to.screenWidth * 0.25,
                                  width: SizeController.to.screenWidth * 0.25,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "클럽 닉네임",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "회원 등급",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.name,
                                  style: const TextStyle(
                                    color: AppColor.textColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  (member.role == "MANAGER")
                                      ? member.clubAuthorityName ?? ""
                                      : (member.role == "ADMIN")
                                          ? "관리자"
                                          : "일반",
                                  style: const TextStyle(
                                    color: AppColor.textColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(32, 32, 32, 16),
                      child: Text(
                        "소개글",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
                        child: Text(
                          member.info ?? "",
                          style: const TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (MemberController.to.clubMember().id !=
                  widget.comment.clubMemberId)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                  child: NextPageButton(
                    text: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          SFSymbols.xmark,
                          color: AppColor.markColor,
                        ),
                        Text(
                          " 이 사용자 보지 않기",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColor.markColor),
                        ),
                      ],
                    ),
                    buttonColor: AppColor.backgroundColor2,
                    onPressed: () {
                      _showBlockClubMember(context);
                    },
                  ),
                ),
            ],
          ),
        );
      }),
      backgroundColor: AppColor.backgroundColor,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
    );
  }

  Future<void> _showBlockClubMember(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Center(
                child: Text(
                  "사용자 차단",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            backgroundColor: AppColor.backgroundColor,
            elevation: 0,
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          '정말로 이 사용자를 차단하시겠습니까?',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      )
                    ]);
              },
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: TextButton(
                      onPressed: Get.back,
                      child: const Text(
                        "취소",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.textColor2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: TextButton(
                      child: const Text(
                        "차단하기",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColor.markColor),
                      ),
                      // buttonColor: AppColor.markColor,
                      onPressed: () async {
                        try {
                          await ClubMemberApiService.postBlockClubMember(
                              clubId: ClubController.to.club.value.id,
                              clubMemberId: widget.comment.clubMemberId);
                          widget.onCommentDeleted();
                          Get.back(); // 경고창 닫기
                          Get.back(); // 바텀 시트 닫기
                          snackBar(
                              title: "사용자가 차단되었습니다",
                              content: "더이상 해당 사용자의 활동이 노출되지 않습니다");
                        } catch (e) {
                          snackBar(
                              title: "사용자를 차단하지 못헸습니다",
                              content: "잠시 후 다시 시도해 주세요");
                          // print('게시글 삭제 중 오류: $e');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ]);
      },
    );
  }
}
