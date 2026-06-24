import 'package:flutter/widgets.dart';

/// 웹용: XFile.path(blob: URL)에서 이미지 미리보기.
Widget previewImageFromPath(
  String path, {
  double? width,
  double? height,
  BoxFit? fit,
}) =>
    Image.network(path, width: width, height: height, fit: fit);
