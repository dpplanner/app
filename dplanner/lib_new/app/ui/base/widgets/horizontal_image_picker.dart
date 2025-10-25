import 'dart:io';

import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/constants/app_colors.dart';

class HorizontalImagePicker extends StatefulWidget {
  final int limit;
  final List<XFile> selectedImages;
  final ValueChanged<List<XFile>> onChanged;

  const HorizontalImagePicker({
    super.key,
    required this.limit,
    required this.selectedImages,
    required this.onChanged,
  });

  @override
  State<HorizontalImagePicker> createState() => _HorizontalImagePickerState();
}

class _HorizontalImagePickerState extends State<HorizontalImagePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: _pickImages,
              child: SvgPicture.asset('assets/images/base_image/base_camera_image.svg'),
            ),
            Positioned(
              right: 5,
              bottom: 5,
              child: Text('${widget.selectedImages.length}/${widget.limit}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: widget.selectedImages.length >= widget.limit
                          ? AppColors.primaryColor
                          : AppColors.textGray)),
            ),
          ],
        ),
        const SizedBox(width: 4.0),
        Expanded(
          child: SizedBox(
            height: 100,
            child: ReorderableListView(
              scrollDirection: Axis.horizontal,
              onReorder: _onReorder,
              children: [
                for (var image in widget.selectedImages)
                  Container(
                    key: ValueKey(image.path),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(File(image.path), fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          top: -5,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _removeImage(image),
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.bgWhite,
                              ),
                              child: const Icon(Icons.close,
                                  size: 12, color: AppColors.textBlack),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImages() async {
    if (widget.selectedImages.length < widget.limit) {
      try {
        List<XFile>? images = await ImagePicker().pickMultiImage(limit: widget.limit);
        if (images.isNotEmpty) {
          List<int> selectedLengths = await Future.wait(
            widget.selectedImages.map((image) async => await image.length()).toList(),
          );

          List<XFile> distinctImages = [];
          for (var image in images) {
            var length = await image.length();
            if (!selectedLengths.contains(length)) {
              distinctImages.add(image);
            }
          }

          if (widget.selectedImages.length + distinctImages.length > widget.limit) {
            return snackBar(title: "${widget.limit}장 이하의 이미지만 추가할 수 있습니다", content: "다시 시도해 주세요");
          }

          if (images.length != distinctImages.length) {
            snackBar(title: "중복된 이미지가 포함되어있습니다", content: "해당 이미지들을 제외하고 추가합니다");
          }

          setState(() {  // 추가된 부분
            widget.onChanged([...widget.selectedImages, ...distinctImages]);
          });
        }
      } catch (e) {
        snackBar(title: "이미지를 불러올 수 없습니다", content: "잠시 후 다시 시도해 주세요");
      }
    }
  }

  void _removeImage(XFile image) {
    final updatedImages = List<XFile>.from(widget.selectedImages)..remove(image);
    setState(() {
      widget.onChanged(updatedImages);
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final List<XFile> updatedImages = List<XFile>.from(widget.selectedImages);
    final XFile item = updatedImages.removeAt(oldIndex);
    updatedImages.insert(newIndex, item);

    setState(() {
      widget.onChanged(updatedImages);
    });
  }
}