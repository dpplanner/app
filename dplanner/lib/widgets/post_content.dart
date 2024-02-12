import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import 'nextpage_button.dart';

class PostContent extends StatelessWidget {
  const PostContent({super.key});

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
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/jin_profile.png',
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
                        Row(
                          children: [
                            const Text(
                              "DP23 남진",
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: SizeController.to.screenWidth * 0.05,
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15),
                                color: AppColor.subColor1, // 배경색 설정
                              ),
                              child: const Text(
                                "관리자",
                                style: TextStyle(
                                  color: AppColor.backgroundColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "2023.11.11 16:28",
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
                IconButton(
                  onPressed: () {
                    _postMore(context);
                  },
                  icon: const Icon(
                    SFSymbols.ellipsis,
                    color: AppColor.textColor,
                  ),
                )
              ],
            ),
            SizedBox(height: SizeController.to.screenHeight * 0.02),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: SizeController.to.screenHeight * 0.01),
                  child: const Text(
                    "공지",
                    style: TextStyle(
                      color: AppColor.textColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
                const Text(
                  "내용\n내용\n내용",
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeController.to.screenHeight * 0.02),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Icon(
                        SFSymbols.pin_fill,
                        color: AppColor.textColor2,
                        size: 14,
                      ),
                      Text(
                        " 고정됨",
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
                          "1",
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
                          SFSymbols.heart,
                          color: AppColor.textColor2,
                          size: 16,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "3",
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
                          SFSymbols.eye,
                          color: AppColor.textColor2,
                          size: 16,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "20",
                          style: TextStyle(
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
    );
  }

  void _postMore(BuildContext context) async {
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
                        " 이 글 신고하기",
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
