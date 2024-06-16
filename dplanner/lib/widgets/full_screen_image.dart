import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dplanner/widgets/nextpage_button.dart';
import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../const/style.dart';

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
                child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    imageUrl: imageUrl,
                    errorWidget: (context, url, error) => SvgPicture.asset(
                          'assets/images/base_image/base_post_image.svg',
                          fit: BoxFit.contain,
                        ),
                    fit: BoxFit.contain)),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(64, 12, 64, 24),
                child: NextPageButton(
                  onPressed: () async {
                    try {
                      var response = await Dio().get(imageUrl,
                          options: Options(responseType: ResponseType.bytes));
                      ImageGallerySaver.saveImage(
                          Uint8List.fromList(response.data),
                          quality: 100,
                          name: imageUrl);
                      Get.back();
                      snackBar(title: "사진이 저장되었습니다", content: "앨범을 확인해 주세요");
                    } catch (e) {
                      print(e.toString());
                      snackBar(title: "사진이 저장되지 않았습니다", content: "잠시 후 다시 시도해 주세요");
                    }
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
