import 'package:flutter/foundation.dart';

class ExceptionUtils {
  static Future<T?> getOrNull<T>(Future<T?> Function() function) async {
    try {
      return await function();
    } catch(e) {

      if (kDebugMode) {
        print(e);
      }

      return null;
    }
  }

  static Future<T?> doOrThrow<T>(Future<T?> Function() function) async {
    try {
      return await function();
    } catch(e) {

      if (kDebugMode) {
        print(e);
      }

      rethrow;
    }
  }
}