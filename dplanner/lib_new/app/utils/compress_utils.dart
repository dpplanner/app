import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class CompressUtils {
  static const int _compressionRate = 80;

  static Future<XFile?> compressImageFile(XFile file) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;

    final outPath = "$tempPath/${DateTime.now().millisecondsSinceEpoch}.jpg";

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.path,
      outPath,
      quality: _compressionRate,
    );

    return compressedFile != null
        ? XFile(compressedFile.path, name: compressedFile.path.split('/').last)
        : null;
  }
}
