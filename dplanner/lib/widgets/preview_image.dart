import 'package:flutter/widgets.dart';

import 'preview_image_io.dart' if (dart.library.html) 'preview_image_web.dart'
    as impl;

/// ImagePicker로 고른 XFile의 로컬 경로를 미리보기로 렌더링한다.
///
/// - 모바일/데스크톱: `dart:io`의 File을 사용해 `Image.file`로 표시
/// - 웹: XFile.path가 `blob:` URL이므로 `Image.network`로 표시
///   (웹에서는 `dart:io`의 File을 쓸 수 없어 조건부 import로 분기)
Widget previewImageFromPath(
  String path, {
  double? width,
  double? height,
  BoxFit? fit,
}) =>
    impl.previewImageFromPath(path, width: width, height: height, fit: fit);
