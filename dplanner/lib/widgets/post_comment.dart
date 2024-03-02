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
import 'package:dplanner/models/post_comment_model.dart';

class PostComment extends StatefulWidget {
  final Post post;
  const PostComment({Key? key, required this.post}) : super(key: key);

  @override
  State<PostComment> createState() => _PostCommentState();
}

class _PostCommentState extends State<PostComment> {
  List<Comment>? _comments;

  @override
  void initState() {
    super.initState();
    fetchComments(widget.post.id);
  }

  Future<void> fetchComments(int postId) async {
    final response = await http.get(
        Uri.parse('http://3.39.102.31:8080/posts/$postId/comments'),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI1MDg1MyIsInJlY2VudF9jbHViX2lkIjoxLCJjbHViX21lbWJlcl9pZCI6MTA0MywiaXNzIjoiZHBsYW5uZXIiLCJpYXQiOjE3MDkzNzE5OTgsImV4cCI6MTcwOTU1MTk5OH0.cI6GclGk93kuBpwQ_abXWKfGURJlZNft58zZc_CmMCk',
        }); //TODO: token값 받아오도록 변경해야함

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData =
          jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> content = responseData['data'];

      setState(() {
        _comments = content.map((data) => Comment.fromJson(data)).toList();
        print(_comments);
      });
    } else {
      throw Exception('Failed to load comments');
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
          children: _comments == null
              ? [
                  const Center(
                    child: Text(
                      "아무것도 없습니다", //TODO: 이거 사라지는데..왜지
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
                child:
                    //comment.profileUrl != null
                    //    ? Image.network(
                    //        comment.profileUrl!,
                    //        height: SizeController.to.screenWidth * 0.09,
                    //        width: SizeController.to.screenWidth * 0.09,
                    //        fit: BoxFit.fill,
                    //      )
                    //    :
                    SvgPicture.asset(
              'assets/images/base_image/base_member_image.svg',
              height: SizeController.to.screenWidth * 0.09,
              width: SizeController.to.screenWidth * 0.09,
              fit: BoxFit.fill,
            )),
            SizedBox(width: SizeController.to.screenWidth * 0.03),
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
                      comment.createdTime != null
                          ? '${comment.createdTime}'
                          : "2023.11.11 16:28", //TODO: nullable아님
                      style: TextStyle(
                        color: AppColor.textColor2,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      width: SizeController.to.screenWidth * 0.03,
                    ),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(5),
                      child: const Text(
                        "댓글 달기",
                        style: TextStyle(
                          color: AppColor.textColor2,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                comment.children.length != 0
                    ? Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/extra/comment_line.svg',
                          ),
                          InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(5),
                            child: Text(
                              "  답글 ${comment.children.length}개 더 보기",
                              style: TextStyle(
                                color: AppColor.textColor2,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      )
                    //  children: [Text(comment.children[0].content)],

                    : Container(),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            _commentMore(context);
          },
          icon: const Icon(
            SFSymbols.ellipsis,
            color: AppColor.textColor,
          ),
        )
      ],
    );
  }

  void _commentMore(BuildContext context) async {
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
