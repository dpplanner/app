import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/controllers/posts.dart';
import 'package:dplanner/pages/post_add_page.dart';
import 'package:dplanner/services/club_member_api_service.dart';
import 'package:dplanner/widgets/report_dialog.dart';
import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/size.dart';
import '../const/style.dart';
import '../models/club_member_model.dart';
import 'nextpage_button.dart';
import 'package:dplanner/models/post_model.dart';
import 'full_screen_image.dart';
import 'package:dplanner/controllers/member.dart';

///
///
/// POST 자세히보기 화면에서 글 내용 그리는 class
///
///

class PostContent extends StatelessWidget {
  final Post post;

  const PostContent({Key? key, required this.post}) : super(key: key);

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Center(
                child: Text(
                  "게시글 삭제",
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
                          '정말로 이 게시글을 삭제하시겠습니까?',
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
                        "삭제하기",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColor.markColor),
                      ),
                      // buttonColor: AppColor.markColor,
                      onPressed: () async {
                        try {
                          await PostController.to.deletePost(post.id);
                          Get.back(); // 경고창 닫기
                          Get.back(); // 바텀 시트 닫기
                          Get.back(); // 삭제된 게시글 나가기
                          snackBar(
                              title: "게시글이 삭제되었습니다", content: "게시판을 확인해 주세요");
                        } catch (e) {
                          snackBar(
                              title: "게시글을 삭제하지 못헸습니다",
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

  Future<void> _showBlockPost(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Center(
                child: Text(
                  "게시글 차단",
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
                          '정말로 이 게시글을 차단하시겠습니까?',
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
                          await PostController.to.blockPost(post.id);
                          Get.back(); // 경고창 닫기
                          Get.back(); // 바텀 시트 닫기
                          Get.back(); // 차단된 게시글 나가기
                          snackBar(
                              title: "게시글이 차단되었습니다",
                              content: "더이상 해당 게시글이 노출되지 않습니다");
                        } catch (e) {
                          snackBar(
                              title: "게시글을 차단하지 못헸습니다",
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

  Future<void> _showReportDialog(BuildContext context, int postId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ReportDialog(targetId: postId, targetType: "POST");
      },
    );
  }

  void _toggleLike() async {
    await PostController.to.toggleLike(post.obs);
  }

  bool hasAuthority() {
    if (MemberController.to.clubMember().role == "ADMIN" ||
        (MemberController.to.clubMember().clubAuthorityTypes != null &&
            MemberController.to
                .clubMember()
                .clubAuthorityTypes!
                .contains("POST_ALL"))) {
      return true;
    } else {
      return false;
    }
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await _clubMemberInfo(memberId: post.clubMemberId);
                      },
                      child: ClipOval(
                        child: post.profileUrl != null
                            ? CachedNetworkImage(
                                placeholder: (context, url) => Container(),
                                imageUrl: post.profileUrl!,
                                errorWidget: (context, url, error) =>
                                    SvgPicture.asset(
                                      'assets/images/base_image/base_member_image.svg',
                                    ),
                                height: SizeController.to.screenWidth * 0.1,
                                width: SizeController.to.screenWidth * 0.1,
                                fit: BoxFit.cover)
                            : SvgPicture.asset(
                                'assets/images/base_image/base_member_image.svg',
                                height: SizeController.to.screenWidth * 0.1,
                                width: SizeController.to.screenWidth * 0.1,
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                    SizedBox(width: SizeController.to.screenWidth * 0.03),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await _clubMemberInfo(
                                    memberId: post.clubMemberId);
                              },
                              child: Text(
                                post.clubMemberName,
                                style: const TextStyle(
                                  color: AppColor.textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: SizeController.to.screenWidth * 0.05,
                            ),
                            post.clubRole == 'ADMIN'
                                ? Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(6, 2, 6, 2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColor.subColor1, // 배경색 설정
                                    ),
                                    child: const Text(
                                      "관리자",
                                      style: TextStyle(
                                        color: AppColor.backgroundColor,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 11,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        Text(
                          DateFormat('M월 d일 HH:mm').format(post.createdTime),
                          style: const TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    _postMore(context, post);
                  },
                  icon: const Icon(
                    SFSymbols.ellipsis,
                    color: AppColor.textColor,
                  ),
                )
              ],
            ),
            SizedBox(height: SizeController.to.screenHeight * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  post.title ?? "제목 없음", //TODO: 제목 생기면 수정해야함
                  style: const TextStyle(
                    color: AppColor.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SelectableLinkify(
                  onOpen: (link) async {
                    if (!await launchUrl(Uri.parse(link.url))) {
                      snackBar(
                          title: "해당 링크로 이동하지 못했습니다",
                          content: "잠시 후 다시 시도해 주세요");
                    }
                  },
                  text: post.content,
                  style: const TextStyle(
                    color: AppColor.textColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                  linkStyle:
                      const TextStyle(decorationColor: AppColor.hyperLink),
                  contextMenuBuilder: (BuildContext context,
                      EditableTextState editableTextState) {
                    return AdaptiveTextSelectionToolbar.editableText(
                      editableTextState: editableTextState,
                    );
                  },
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: post.attachmentsUrl.map((imageUrl) {
                      String formattedUrl = imageUrl.startsWith('https://')
                          ? imageUrl
                          : 'https://$imageUrl';
                      return GestureDetector(
                          onTap: () {
                            // Getx의 Get.to()를 사용하여 전체 화면 이미지 페이지로 이동
                            Get.to(
                                () => FullScreenImage(imageUrl: formattedUrl));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CachedNetworkImage(
                                placeholder: (context, url) => Container(),
                                imageUrl: formattedUrl,
                                errorWidget: (context, url, error) =>
                                    SvgPicture.asset(
                                      'assets/images/base_image/base_post_image.svg',
                                    ),
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover),
                          ));
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeController.to.screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (post.isFixed)
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        SFSymbols.pin_fill,
                        color: AppColor.objectColor,
                        size: 14,
                      ),
                      Text(
                        '고정됨',
                        style: TextStyle(
                          color: AppColor.objectColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                const Expanded(child: SizedBox()),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            const Icon(
                              SFSymbols.text_bubble,
                              color: AppColor.textColor2,
                              size: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                '${post.commentCount}',
                                style: const TextStyle(
                                  color: AppColor.textColor2,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _toggleLike,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Icon(
                                post.likeStatus
                                    ? SFSymbols.heart_fill
                                    : SFSymbols.heart,
                                color: post.likeStatus
                                    ? AppColor.objectColor
                                    : AppColor.textColor2,
                                size: 18,
                              ),
                            ),
                            Text(
                              '${post.likeCount}',
                              style: TextStyle(
                                color: post.likeStatus
                                    ? AppColor.objectColor
                                    : AppColor.textColor2,
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _postMore(BuildContext context, Post post) async {
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
              post.clubMemberId == MemberController.to.clubMember().id
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                      child: NextPageButton(
                        buttonColor: AppColor.backgroundColor2,
                        text: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(SFSymbols.pencil_outline,
                                color: AppColor.textColor, size: 18),
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
                          Get.to(PostAddPage(
                            isEdit: true,
                            post: post,
                            clubID: post.clubId,
                          ));
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                      child: NextPageButton(
                        buttonColor: AppColor.backgroundColor2,
                        text: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              SFSymbols.xmark,
                              color: AppColor.markColor,
                            ),
                            Text(
                              " 이 게시글 보지 않기",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.markColor),
                            ),
                          ],
                        ),
                        onPressed: () {
                          _showBlockPost(context);
                        },
                      ),
                    ),
              hasAuthority() ||
                      post.clubMemberId == MemberController.to.clubMember().id
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                      child: NextPageButton(
                        buttonColor: AppColor.backgroundColor2,
                        text: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(SFSymbols.trash,
                                color: AppColor.markColor, size: 18),
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
                          _showDeleteConfirmationDialog(context);
                          //  Get.back();
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
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
                              " 이 글 신고하기",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.markColor),
                            ),
                          ],
                        ),
                        onPressed: () {
                          _showReportDialog(context, post.id);
                        },
                      ),
                    ),
              hasAuthority()
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                      child: NextPageButton(
                        buttonColor: AppColor.backgroundColor2,
                        text: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(SFSymbols.pin_fill,
                                color: AppColor.textColor, size: 18),
                            Text(
                              post.isFixed
                                  ? " 게시글 고정 해제하기"
                                  : " 게시글 고정하기", //TODO 고정 되어있으면 풀리게
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.textColor),
                            ),
                          ],
                        ),
                        onPressed: () {
                          PostController.to.fixPost(post.id);
                        },
                      ),
                    )
                  : Container()
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
              if (MemberController.to.clubMember().id != post.clubMemberId)
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
                          await PostController.to.deleteClubMemberPosts(
                              post.clubId, post.clubMemberId);
                          Get.back(); // 경고창 닫기
                          Get.back(); // 바텀 시트 닫기
                          Get.back(); // 차단된 사용자의 게시글 나가기
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
