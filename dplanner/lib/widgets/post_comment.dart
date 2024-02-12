import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import 'nextpage_button.dart';

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
                            SvgPicture.asset(
                              'assets/images/comment_line.svg',
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
                  onPressed: () {
                    _commentMore(context);
                  },
                  icon: const Icon(
                    SFSymbols.ellipsis,
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
                  'assets/images/showmodal_scrollcontrolbar.svg',
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
