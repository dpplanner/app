import 'package:cached_network_image/cached_network_image.dart';
import 'package:dplanner/pages/post_add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/size.dart';
import '../style.dart';
import 'nextpage_button.dart';
import 'package:dplanner/models/post_model.dart';
import 'package:dplanner/services/club_post_api_service.dart';
import 'full_screen_image.dart';
import 'package:dplanner/controllers/member.dart';

///
///
/// POST 자세히보기 화면에서 글 내용 그리는 class
///
///

class PostContent extends StatefulWidget {
  final Post post;

  const PostContent({Key? key, required this.post}) : super(key: key);

  @override
  State<PostContent> createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  late bool isLiked = widget.post.likeStatus;
  late int likeCount = widget.post.likeCount;

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('게시글 삭제'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('정말로 이 게시글을 삭제하시겠습니까?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await PostApiService.deletePost(widget.post.id);
                  Get.back();
                  Get.back();
                  Get.snackbar('알림', '게시글이 성공적으로 삭제되었습니다.');
                } catch (e) {
                  Get.snackbar('알림', '게시글 삭제 중 오류가 발생했습니다.');
                  print('게시글 삭제 중 오류: $e');
                }
              },
              child: Text('예'),
            ),
          ],
        );
      },
    );
  }

  void _toggleLike() async {
    try {
      final bool newLikeStatus =
          await PostApiService.toggleLike(widget.post.id);
      setState(() {
        isLiked = newLikeStatus;
        if (isLiked) {
          likeCount += 1;
        } else {
          likeCount -= 1;
        }
      });
    } catch (e) {
      Get.snackbar('알림', '오류가 발생했습니다. 다시 시도해주세요: $e');
    }
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
                    ClipOval(
                      child: widget.post.profileUrl != null
                          ? CachedNetworkImage(
                              placeholder: (context, url) => Container(),
                              imageUrl: widget.post.profileUrl!,
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
                    SizedBox(width: SizeController.to.screenWidth * 0.03),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.post.clubMemberName,
                              style: const TextStyle(
                                color: AppColor.textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: SizeController.to.screenWidth * 0.05,
                            ),
                            widget.post.clubRole == 'ADMIN'
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
                          DateFormat('M월 d일')
                              .add_jm()
                              .format(widget.post.createdTime),
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
                    _postMore(context, widget.post);
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
                Padding(
                  padding: EdgeInsets.only(
                      bottom: SizeController.to.screenHeight * 0.01),
                  child: Text(
                    widget.post.title ?? "제목없음", //TODO: 제목 생기면 수정해야함
                    style: TextStyle(
                      color: AppColor.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  widget.post.content,
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: widget.post.attachmentsUrl.map((imageUrl) {
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
                widget.post.isFixed
                    ? Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Icon(
                              SFSymbols.pin_fill,
                              color: AppColor.objectColor,
                              size: 14,
                            ),
                            Text(
                              " 고정됨",
                              style: TextStyle(
                                color: AppColor.objectColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(
                          SFSymbols.text_bubble,
                          color: AppColor.textColor2,
                          size: 16,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${widget.post.commentCount}',
                          style: TextStyle(
                            color: AppColor.textColor2,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: _toggleLike,
                          child: Icon(
                            isLiked ? SFSymbols.heart_fill : SFSymbols.heart,
                            color: AppColor.textColor2,
                            size: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${likeCount}',
                          style: TextStyle(
                            color: AppColor.textColor2,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
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
              if (widget.post.clubMemberId ==
                  MemberController.to.clubMember().id)
                Padding(
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
                ),
              hasAuthority() ||
                      widget.post.clubMemberId ==
                          MemberController.to.clubMember().id
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
                              " 이 글 신고하기",
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
              hasAuthority()
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                      child: NextPageButton(
                        buttonColor: AppColor.backgroundColor2,
                        text: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(SFSymbols.pin_fill,
                                color: AppColor.textColor, size: 18),
                            Text(
                              widget.post.isFixed
                                  ? " 게시글 고정 해제하기"
                                  : " 게시글 고정하기", //TODO 고정 되어있으면 풀리게
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.textColor),
                            ),
                          ],
                        ),
                        onPressed: () {
                          PostApiService.fixPost(post.id);
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
}
