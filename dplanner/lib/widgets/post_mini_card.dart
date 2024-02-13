import 'package:dplanner/controllers/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../style.dart';

class PostMiniCard extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final bool isPhoto;

  const PostMiniCard(
      {super.key,
      required this.title,
      required this.content,
      required this.date,
      this.isPhoto = false});

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
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                  Text(
                    content,
                    style: const TextStyle(
                        color: AppColor.textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                        color: AppColor.textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isPhoto)
              SvgPicture.asset(
                'assets/images/post_add_photo.svg',
                height: 64,
                width: 64,
              )
          ],
        ),
      ),
    );
  }
}
