import 'package:dplanner/pages/post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import 'package:dplanner/models/post_model.dart';

///
///
/// 클럽 홈에서 POST 리스트 컨텐츠를 보여줄 때 사용되는 단일 컨텐츠용 CARD
///
///
class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String modifyImageUrl(String url) {
    // "file:///"을 삭제하고 URL 가져오기
    if (url.startsWith("file:///")) {
      url = url.replaceFirst("file:///", "");
    }
    // 이미 "https://"로 시작하는지 확인하고 아닌 경우에만 "https://"를 추가
    if (!url.startsWith("https://")) {
      url = "https://" + url;
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColor.subColor2.withOpacity(0.8),
      highlightColor: AppColor.subColor2.withOpacity(0.8),
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.to(PostPage(post: widget.post), arguments: 1);
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
                        ClipOval(
                          child: widget.post.profileUrl != null
                              ? Image.network(
                                  modifyImageUrl(widget.post.profileUrl!),
                                  height: SizeController.to.screenWidth * 0.1,
                                  width: SizeController.to.screenWidth * 0.1,
                                  fit: BoxFit.fill,
                                )
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
                            Text(
                              widget.post.clubMemberName,
                              style: const TextStyle(
                                color: AppColor.textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
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
                    widget.post.clubRole == 'ADMIN'
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
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                SizedBox(height: SizeController.to.screenHeight * 0.02),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: SizeController.to.screenHeight * 0.01),
                      child: Text(
                        widget.post.title != null
                            ? widget.post.title!
                            : "제목 없음", //제목 생기면 그때 수정할 것
                        style: const TextStyle(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      widget.post.content,
                      style: const TextStyle(
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
                    if (widget.post.isFixed)
                      const Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Icon(
                              SFSymbols.pin_fill,
                              color: AppColor.textColor2,
                              size: 14,
                            ),
                            Text(
                              '고정됨',
                              style: TextStyle(
                                color: AppColor.textColor2,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          const Expanded(
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
                              style: const TextStyle(
                                color: AppColor.textColor2,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Icon(
                              widget.post.likeStatus
                                  ? SFSymbols.heart_fill
                                  : SFSymbols.heart,
                              color: AppColor.textColor2,
                              size: 16,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${widget.post.likeCount}',
                              style: const TextStyle(
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
        ),
      ),
    );
  }
}
