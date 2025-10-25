import 'package:flutter/material.dart';

import '../../../../base/widgets/image_carousel.dart';

class ImageInfoRow extends StatelessWidget {
  final String title;
  final List<String> imageUrls;

  const ImageInfoRow({super.key, required this.title, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ImageCarousel(imageUrls: imageUrls))
        ]),
      ),
    );
  }
}
