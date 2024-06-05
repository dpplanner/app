import 'package:flutter/material.dart';

import '../controllers/size.dart';
import '../style.dart';
import 'comment_block.dart';
import 'package:dplanner/models/post_comment_model.dart';

///
///
/// POST 자세히보기 화면에서 댓글 내용 그리는 class
///
///
class PostComment extends StatelessWidget {
  final List<Comment> comments;
  final int? selectedCommentId;
  final Function(int?) onCommentSelected;
  final void Function() onCommentDeleted;

  const PostComment(
      {Key? key,
        required this.comments,
        required this.selectedCommentId,
        required this.onCommentSelected,
        required this.onCommentDeleted,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeController.to.screenWidth,
      color: AppColor.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: comments.isEmpty
            ? [
          const SizedBox(
            height: 24,
          ),
          const Center(
            child: Text(
              "댓글이 없습니다",
            ),
          ),
        ]
            : [
          // 댓글 데이터를 화면에 표시하는 부분
          for (var comment in comments)
            CommentBlock(
                isSelected: comment.id == selectedCommentId ? true : false,
                comment: comment,
                onCommentSelected: onCommentSelected,
                onCommentDeleted: onCommentDeleted
            ),
        ],
      ),
    );
  }
}
