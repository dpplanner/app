import 'dart:io';

import 'package:flutter/widgets.dart';

/// 모바일/데스크톱용: 로컬 파일에서 이미지 미리보기.
Widget previewImageFromPath(
  String path, {
  double? width,
  double? height,
  BoxFit? fit,
}) =>
    Image.file(File(path), width: width, height: height, fit: fit);
