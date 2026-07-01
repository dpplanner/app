import 'dart:typed_data';

import 'download_image_stub.dart'
    if (dart.library.html) 'download_image_web.dart' as impl;

/// 웹에서 이미지 바이트를 브라우저 다운로드로 저장한다.
/// (모바일은 image_gallery_saver를 쓰므로 이 경로를 타지 않음 — stub은 no-op)
Future<void> downloadImageWeb(Uint8List bytes, String filename) =>
    impl.downloadImageWeb(bytes, filename);
