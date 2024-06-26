import 'package:cached_network_image/cached_network_image.dart';
import 'package:dplanner/controllers/posts.dart';
import 'package:dplanner/pages/post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/size.dart';
import '../const/style.dart';
import 'package:dplanner/models/post_model.dart';

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
                          ClipOval(
                            child: rxPost.value.profileUrl != null
                                ? CachedNetworkImage(
                                placeholder: (context, url) => Container(),
                                imageUrl: rxPost.value.profileUrl!,
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
                              Text(
                                rxPost.value.clubMemberName,
                                style: const TextStyle(
                                  color: AppColor.textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
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
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: SizeController.to.screenHeight * 0.01),
                        child: Text(
                          rxPost.value.title != null
                              ? rxPost.value.title!
                              : "제목 없음", //제목 생기면 그때 수정할 것
                          style: const TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      buildPostContent(rxPost.value.content),
                    ],
                  ),
                  SizedBox(height: SizeController.to.screenHeight * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      rxPost.value.isFixed
                          ? const Expanded(
                        flex: 1,
                        child: Row(
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
                      )
                          : const Expanded(child: SizedBox()),
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
                                '${rxPost.value.commentCount}',
                                style: const TextStyle(
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
                                  child: rxPost.value.likeStatus
                                      ? const Icon(
                                    SFSymbols.heart_fill,
                                    color: AppColor.objectColor,
                                    size: 16,
                                  )
                                      : const Icon(
                                    SFSymbols.heart,
                                    color: AppColor.textColor2,
                                    size: 16,
                                  ),
                                )
                            ),
                            Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: _toggleLike,
                                  child: Text(
                                    '${rxPost.value.likeCount}',
                                    style: rxPost.value.likeStatus
                                        ? const TextStyle(
                                      color: AppColor.objectColor,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    )
                                        : const TextStyle(
                                      color: AppColor.textColor2,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
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
    });
  }
}
