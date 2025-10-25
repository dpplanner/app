import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../config/constants/app_colors.dart';
import '../pages/full_screen_image_page.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> imageUrls;

  const ImageCarousel({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return ExpandableCarousel(
      options: ExpandableCarouselOptions(enlargeCenterPage: true),
      items: imageUrls.map((imageUrl) {
        String formattedUrl = imageUrl.startsWith('https://') ? imageUrl : 'https://$imageUrl';
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: GestureDetector(
            onTap: () {
              Get.to(() => FullScreenImagePage(
                  imageUrls: imageUrls, initialIndex: imageUrls.indexOf(imageUrl)));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.textBlack.withOpacity(0.5),
                      blurRadius: 2,
                      offset: Offset(2, 4))
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(color: AppColors.subColor5),
                    imageUrl: formattedUrl,
                    errorWidget: (context, url, error) =>
                        SvgPicture.asset('assets/images/base_image/base_post_image.svg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
