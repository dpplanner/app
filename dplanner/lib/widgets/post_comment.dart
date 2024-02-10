import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';

import '../controllers/size.dart';
import '../style.dart';

class PostComment extends StatelessWidget {
  const PostComment({super.key});

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/jin_profile.png',
                        height: SizeController.to.screenWidth * 0.09,
                        width: SizeController.to.screenWidth * 0.09,
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
                            const Text(
                              "DP23 남진",
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
                        const Text(
                          "댓글\n댓글",
                          style: TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              "2023.11.11 16:28",
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
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/comment_line.png',
                              fit: BoxFit.fill,
                            ),
                            InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(5),
                              child: const Text(
                                "  답글 2개 더 보기",
                                style: TextStyle(
                                  color: AppColor.textColor2,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    SFSymbols.ant,
                    color: AppColor.textColor,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
