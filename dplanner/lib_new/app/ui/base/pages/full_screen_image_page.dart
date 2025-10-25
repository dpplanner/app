import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../config/constants/app_colors.dart';
import '../widgets/snackbar.dart';
import 'loading_page.dart';

class FullScreenImagePage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImagePage({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  late PageController _pageController;
  late String _currentImageUrl;
  late List<String> _formattedUrls;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _formattedUrls = widget.imageUrls
        .map((imageUrl) => imageUrl.startsWith('https://') ? imageUrl : 'https://$imageUrl')
        .toList();
    _currentImageUrl = _formattedUrls[widget.initialIndex];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changePage(index) {
    setState(() {
      _currentImageUrl = _formattedUrls[index];
    });
  }

  Future<void> _downloadImage() async {
    try {
      var response =
          await Dio().get(_currentImageUrl, options: Options(responseType: ResponseType.bytes));
      ImageGallerySaver.saveImage(Uint8List.fromList(response.data),
          quality: 100, name: _currentImageUrl);
      snackBar(title: "사진이 저장되었습니다", content: "앨범을 확인해 주세요");
    } catch (e) {
      snackBar(title: "사진이 저장되지 않았습니다", content: "잠시 후 다시 시도해 주세요");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textBlack,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(SFSymbols.xmark),
          color: AppColors.bgWhite,
        ),
        actions: [
          IconButton(
            onPressed: _downloadImage,
            icon: const Icon(Icons.download),
            color: AppColors.bgWhite,
          )
        ],
      ),
      body: SafeArea(
          child: PhotoViewGallery.builder(
        itemCount: _formattedUrls.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(_formattedUrls[index]),
            initialScale: PhotoViewComputedScale.contained,
            errorBuilder: (context, error, _) => SvgPicture.asset('assets/images/base_image/base_post_image.svg')
          );
        },
        loadingBuilder: (context, _) => const LoadingPage(),
        pageController: _pageController,
        onPageChanged: _changePage,
      )),
    );
  }
}
