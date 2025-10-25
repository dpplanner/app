import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../base/widgets/horizontal_image_picker.dart';

class ImagePickerRow extends StatelessWidget {
  final String title;
  final int limit;
  final List<XFile> selectedImages;
  final ValueChanged<List<XFile>> onChanged;

  const ImagePickerRow({
    super.key,
    required this.title,
    required this.limit,
    required this.selectedImages,
    required this.onChanged,
  });

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
              child: HorizontalImagePicker(
                  limit: limit, selectedImages: selectedImages, onChanged: onChanged))
        ]),
      ),
    );
  }
}
