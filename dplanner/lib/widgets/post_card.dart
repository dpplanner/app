import 'package:dplanner/pages/post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import 'package:dplanner/models/post_model.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColor.subColor2.withOpacity(0.8),
      highlightColor: AppColor.subColor2.withOpacity(0.8),
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.to(const PostPage(), arguments: 1);
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
                            Text(
                              post.clubMemberName,
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${post.createdTime}',
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15),
                        color: AppColor.subColor1, // 배경색 설정
                      ),
                      child: Text(
                        post.clubRole,
                        style: TextStyle(
                          color: AppColor.backgroundColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeController.to.screenHeight * 0.02),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: SizeController.to.screenHeight * 0.01),
                      child: Text(
                        "공지", //제목 생기면 그때 수정할 것
                        style: TextStyle(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      post.content,
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
                    if (post.isFixed)
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
                              '${post.commentCount}',
                              style: TextStyle(
                                color: AppColor.textColor2,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Icon(
                              post.likeStatus
                                  ? SFSymbols.heart_fill
                                  : SFSymbols.heart,
                              color: AppColor.textColor2,
                              size: 16,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${post.likeCount}',
                              style: TextStyle(
                                color: AppColor.textColor2,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          //Expanded(
                          //  flex: 1,
                          //  child: Icon(
                          //    SFSymbols.eye,
                          //    color: AppColor.textColor2,
                          //    size: 16,
                          //  ),
                          //),
                          //Expanded(
                          //  flex: 1,
                          //  child: Text(
                          //    "20",
                          //    style: TextStyle(
                          //      color: AppColor.textColor2,
                          //      fontWeight: FontWeight.w500,
                          //      fontSize: 16,
                          //    ),
                          //  ),
                          //),
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
