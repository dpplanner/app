import 'package:dplanner/widgets/nextpage_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../style.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.textColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  icon:
                      const Icon(Icons.close, color: AppColor.backgroundColor),
                  onPressed: () {
                    Get.back();
                  }),
            ),
            Expanded(
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(64, 12, 64, 24),
                child: NextPageButton(
                  onPressed: () {
                    Get.back();
                  },
                  buttonColor: AppColor.objectColor,
                  text: const Text(
                    "이 사진 다운로드하기",
                    style: TextStyle(
                      color: AppColor.backgroundColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
