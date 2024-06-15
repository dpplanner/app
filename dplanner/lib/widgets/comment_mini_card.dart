import 'package:flutter/material.dart';
import 'package:dplanner/controllers/size.dart';

import '../const/style.dart';
import 'package:dplanner/models/post_comment_model.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  const CommentCard({required this.comment, super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment.content,
              style: const TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
            Text(
              '${comment.createdTime}',
              style: const TextStyle(
                  color: AppColor.textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
