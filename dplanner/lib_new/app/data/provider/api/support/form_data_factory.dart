import 'dart:convert';

import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:image_picker/image_picker.dart';

class FormDataFactory {
  static Future<FormData> create(Map<String, dynamic> data) async {
    var formData = FormData({});
    for (var entry in data.entries) {
      if (entry.value == null) continue;

      if (entry.value is List) {
        for (var content in entry.value) {
          formData.files.add(MapEntry(entry.key, await _getMultipartFile(content)));
        }
      } else {
        formData.files.add(MapEntry(entry.key, await _getMultipartFile(entry.value)));
      }
    }
    return formData;
  }

  /// private
  static Future<MultipartFile> _getMultipartFile(dynamic content) async {
    if (content is XFile) {
      return MultipartFile(await content.readAsBytes(), filename: content.name);
    } else {
      return MultipartFile(utf8.encode(jsonEncode(content)),
          filename: 'temp_${DateTime.timestamp()}.json',
          contentType: 'application/json');
    }
  }
}
