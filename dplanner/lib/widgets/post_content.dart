import 'package:dplanner/pages/post_add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../controllers/size.dart';
import '../style.dart';
import 'nextpage_button.dart';
import 'package:dplanner/models/post_model.dart';

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
                await _deletePost(context);
              },
              child: Text('예'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePost(BuildContext context) async {
    final url = Uri.parse('http://3.39.102.31:8080/posts/${widget.post.id}');
    final headers = {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI1MDg1MyIsInJlY2VudF9jbHViX2lkIjoxLCJjbHViX21lbWJlcl9pZCI6MTA0MywiaXNzIjoiZHBsYW5uZXIiLCJpYXQiOjE3MDkzODQ1MjAsImV4cCI6MTcwOTU2NDUyMH0.aaQFRCYkHMA5k6Ot8rIEEdQKXivC5H0Th3O-TaArmWU',
    };

    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode == 204) {
        Get.snackbar('알림', '게시글이 성공적으로 삭제되었습니다.');
        Get.back();
      } else {
        Get.snackbar('알림', '게시글이 성공적으로 삭제되지 못했습니다.${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('알림', '오류가 발생했습니다.');
    }
  }

  void _toggleLike() async {
    final url =
        Uri.parse('http://3.39.102.31:8080/posts/${widget.post.id}/like');
    final headers = {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI1MDg1MyIsInJlY2VudF9jbHViX2lkIjoxLCJjbHViX21lbWJlcl9pZCI6MTA0MywiaXNzIjoiZHBsYW5uZXIiLCJpYXQiOjE3MDkzODQ1MjAsImV4cCI6MTcwOTU2NDUyMH0.aaQFRCYkHMA5k6Ot8rIEEdQKXivC5H0Th3O-TaArmWU',
    };

    try {
      final response = await http.put(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data']['status'] == 'LIKE') {
          setState(() {
            isLiked = true;
            likeCount += 1; //서버에서 실시간으로 좋아요가 올라가는건 페이지를 새로고침해야지만 볼 수 있음
          });
        } else if (data['data']['status'] == 'DISLIKE') {
          setState(() {
            isLiked = false;
            likeCount -= 1;
          });
        }
      } else {
        Get.snackbar('알림', '오류가 발생했습니다. 다시 시도해주세요  no ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('알림', '오류가 발생했습니다. 다시 시도해주세요 ${e}');
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
                      child: SvgPicture.asset(
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
                                fontWeight: FontWeight.w600,
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
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        Text(
                          '${widget.post.createdTime}',
                          style: const TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w500,
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
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: SizeController.to.screenHeight * 0.01),
                  child: const Text(
                    "공지", //TODO: 제목 생기면 수정해야함
                    style: TextStyle(
                      color: AppColor.textColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  widget.post.content,
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
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
                              color: AppColor.textColor2,
                              size: 14,
                            ),
                            Text(
                              " 고정됨",
                              style: TextStyle(
                                color: AppColor.textColor2,
                                fontWeight: FontWeight.w500,
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
                            fontWeight: FontWeight.w500,
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
                            fontWeight: FontWeight.w500,
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
              Padding(
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
                    Get.to(PostAddPage(
                      isEdit: true,
                      post: post,
                    ));
                  },
                ),
              ),
              Padding(
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
                    _showDeleteConfirmationDialog(context);
                    //  Get.back();
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
