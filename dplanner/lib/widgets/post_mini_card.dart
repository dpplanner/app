import 'package:dplanner/controllers/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../style.dart';

class PostMiniCard extends StatelessWidget {
  final String title;
  final String content;
  final DateTime dateTime;
  final bool isPhoto;

  const PostMiniCard(
      {super.key,
      required this.title,
      required this.content,
      required this.dateTime,
      this.isPhoto = false});

  Widget buildPostContent(String content) {
    final cutoff = 100;
    final shouldShowMore = content.length > cutoff;

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: AppColor.textColor,
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
        children: <TextSpan>[
          TextSpan(
            text: shouldShowMore ? content.substring(0, cutoff) : content,
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
    return Container(
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
    );
  }
}
