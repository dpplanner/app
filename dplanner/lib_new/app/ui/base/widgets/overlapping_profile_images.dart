import 'dart:math';

import 'package:flutter/material.dart';
import 'profile_image.dart'; // ProfileImage 위젯을 import 해야 함

class OverlappingProfileImages extends StatelessWidget {
  final List<String?> imageUrls;
  final int maxDisplayImages;
  final double imageSize;
  final Color borderColor;
  final double borderWidth;

  const OverlappingProfileImages({
    super.key,
    required this.imageUrls,
    this.maxDisplayImages = 3,
    this.imageSize = 30,
    this.borderColor = Colors.white,
    this.borderWidth = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final displayCount = min(imageUrls.length, maxDisplayImages);

    return SizedBox(
      height: imageSize,
      width: _calculateWidth(displayCount),
      child: Stack(
        children: [
          for (int i = 0; i < displayCount; i++)
            Positioned(
              left: i * (imageSize / 2.5),
              child: Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: borderWidth),
                ),
                child: ProfileImage(
                  profileImageUrl: imageUrls[i],
                  size: imageSize,
                ),
              ),
            ),
        ].reversed.toList(), // 가장 앞에 있는 이미지가 위로 오도록
      ),
    );
  }

  double _calculateWidth(int count) {
    if (count <= 1) return imageSize;
    return imageSize + (count - 1) * (imageSize / 2.5);
  }
}