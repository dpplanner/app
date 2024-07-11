import 'package:cached_network_image/cached_network_image.dart';
import 'package:dplanner/controllers/posts.dart';
import 'package:dplanner/pages/post_page.dart';
import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/club.dart';
import '../controllers/size.dart';
import '../const/style.dart';
import 'package:dplanner/models/post_model.dart';

import '../models/club_member_model.dart';
import '../services/club_member_api_service.dart';
import 'nextpage_button.dart';

///
///
/// 클럽 홈에서 POST 리스트 컨텐츠를 보여줄 때 사용되는 단일 컨텐츠용 CARD
///
///
class PostCard extends StatelessWidget {
  final Rx<Post> rxPost;

  const PostCard({Key? key, required this.rxPost}) : super(key: key);

  void _toggleLike() async {
    await PostController.to.toggleLike(rxPost);
  }

  int _getPostCardContentLength(String content) {
    const contentCutoff = 100;
    if (content.length > contentCutoff) return contentCutoff;

    int newLineCount = 0;
    for (int i = 0; i < content.length; i++) {
      if (content[i] == '\n') {
        newLineCount++;
        if (newLineCount > 3) return i;
      }
    }

    return content.length;
  }

  Widget buildPostContent(String content) {
    final postCardContentLength = _getPostCardContentLength(content);
    final shouldShowMore = postCardContentLength < content.length;

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: AppColor.textColor,
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
        children: <TextSpan>[
          TextSpan(
            text: content.substring(0, postCardContentLength),
          ),
          if (shouldShowMore)
            const TextSpan(
              text: '... 더 보기',
              style: TextStyle(
                color: AppColor.subColor3,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return InkWell(
        splashColor: AppColor.subColor2.withOpacity(0.8),
        highlightColor: AppColor.subColor2.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.to(PostPage(postId: rxPost.value.id), arguments: 1);
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColor.backgroundColor,
          ),
          child: Container(
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
                              await _clubMemberInfo(
                                  memberId: rxPost.value.clubMemberId);
                            },
                            child: ClipOval(
                              child: rxPost.value.profileUrl != null
                                  ? CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          Container(),
                                      imageUrl: rxPost.value.profileUrl!,
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
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                          SizedBox(width: SizeController.to.screenWidth * 0.03),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await _clubMemberInfo(
                                      memberId: rxPost.value.clubMemberId);
                                },
                                child: Text(
                                  rxPost.value.clubMemberName,
                                  style: const TextStyle(
                                    color: AppColor.textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat('M월 d일')
                                    .add_jm()
                                    .format(rxPost.value.createdTime),
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
                      rxPost.value.clubRole == 'ADMIN'
                          ? Container(
                              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15),
                                color: AppColor.subColor1, // 배경색 설정
                              ),
                              child: const Text(
                                '관리자',
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
                  SizedBox(height: SizeController.to.screenHeight * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rxPost.value.title != null
                            ? rxPost.value.title!
                            : "제목 없음", //제목 생기면 그때 수정할 것
                        style: const TextStyle(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      buildPostContent(rxPost.value.content),
                    ],
                  ),
                  SizedBox(height: SizeController.to.screenHeight * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (rxPost.value.isFixed)
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
                            onTap: () {
                              Get.to(
                                  () => PostPage(
                                        postId: rxPost.value.id,
                                        scrollToComments: true,
                                      ),
                                  arguments: 1);
                            },
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
                                      '${rxPost.value.commentCount}',
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
                                      rxPost.value.likeStatus
                                          ? SFSymbols.heart_fill
                                          : SFSymbols.heart,
                                      color: rxPost.value.likeStatus
                                          ? AppColor.objectColor
                                          : AppColor.textColor2,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                    '${rxPost.value.likeCount}',
                                    style: TextStyle(
                                      color: rxPost.value.likeStatus
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
          ),
        ),
      );
    });
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
                              clubId: rxPost.value.clubId,
                              clubMemberId: rxPost.value.clubMemberId);
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
