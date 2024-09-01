import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../utils/exception_utils.dart';

class SecureStorageService extends GetxService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _accessTokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";

  Future<String?> getAccessToken() async {
    return await _read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _read(key: _refreshTokenKey);
  }

  Future<void> writeAccessToken(String accessToken) async {
    await _write(key: _accessTokenKey, value: accessToken);
  }

  Future<void> writeRefreshToken(String refreshToken) async {
    await _write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<void> deleteAccessToken(String accessToken) async {
    await _delete(key: _accessTokenKey);
  }

  Future<void> deleteRefreshToken(String refreshToken) async {
    await _delete(key: _refreshTokenKey);
  }

  /*
  * private methods
  */

  Future<String?> _read({required String key}) {
    return ExceptionUtils.getOrNull(() => _storage.read(key: key));
  }

  Future<void> _write({required String key, required String value}) {
    return ExceptionUtils.doOrThrow(() => _storage.write(key: key, value: value));
  }

  Future<void> _delete({required String key}) {
    return ExceptionUtils.doOrThrow(() => _storage.delete(key: key));
  }
}