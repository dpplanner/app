import 'package:dplanner/controllers/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../pages/post_page.dart';
import '../const/style.dart';

class PostMiniCard extends StatelessWidget {
  final int id;
  final String title;
  final String content;
  final DateTime dateTime;
  final bool isPhoto;

  const PostMiniCard(
      {super.key,
      required this.id,
      required this.title,
      required this.content,
      required this.dateTime,
      this.isPhoto = false});

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
                  fontSize: 16),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Get.to(PostPage(postId: id), arguments: 1);
        },
        child: Container(
          width: SizeController.to.screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColor.backgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      buildPostContent(content),
                      Text(
                        DateFormat('yyyy년 M월 d일').add_jm().format(dateTime),
                        style: const TextStyle(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isPhoto)
                  SvgPicture.asset(
                    'assets/images/base_image/base_post_image.svg',
                    height: 64,
                    width: 64,
                  )
              ],
            ),
          ),
        ));
  }
}
