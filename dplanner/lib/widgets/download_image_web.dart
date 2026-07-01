import 'dart:html' as html;
import 'dart:typed_data';

/// 웹용: Blob + anchor click로 파일 다운로드.
Future<void> downloadImageWeb(Uint8List bytes, String filename) async {
  final blob = html.Blob(<dynamic>[bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..download = filename
    ..click();
  html.Url.revokeObjectUrl(url);
}
