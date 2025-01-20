import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../utils/exception_utils.dart';

class SecureStorageService extends GetxService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _accessTokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";
  static const String _eulaAgreedKey = "eula";
  static const String _loginInfoKey = "login_info";

  Future<String?> getAccessToken() async {
    return await _read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _read(key: _refreshTokenKey);
  }

  Future<bool?> getEulaAgreed() async {
    return await _read(key: _eulaAgreedKey) == 'true';
  }

  Future<String?> getLoginInfo() async {
    return _read(key: _loginInfoKey);
  }

  Future<void> writeAccessToken(String accessToken) async {
    await _write(key: _accessTokenKey, value: accessToken);
  }

  Future<void> writeRefreshToken(String refreshToken) async {
    await _write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<void> writeEulaAgreed(bool eulaAgreed) async {
    await _write(key: _eulaAgreedKey, value: eulaAgreed.toString());
  }

  Future<void> writeLoginInfo(
      {required String email,
      required String name,
      required String type}) async {
    await _write(key: _loginInfoKey, value: '$email $name $type');
  }

  Future<void> updateAccessToken(String accessToken) async {
    await _delete(key: _accessTokenKey);
    await _write(key: _accessTokenKey, value: accessToken);
  }

  Future<void> updateRefreshToken(String refreshToken) async {
    await _delete(key: _refreshTokenKey);
    await _write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<void> deleteAll() async {
    await _delete(key: _accessTokenKey);
    await _delete(key: _refreshTokenKey);
    await _delete(key: _eulaAgreedKey);
  }

  /*
  * private methods
  */
  Future<String?> _read({required String key}) {
    return ExceptionUtils.getOrNull(() => _storage.read(key: key));
  }

  Future<void> _write({required String key, required String value}) {
    return ExceptionUtils.doOrThrow(
        () => _storage.write(key: key, value: value));
  }

  Future<void> _delete({required String key}) {
    return ExceptionUtils.doOrThrow(() => _storage.delete(key: key));
  }
}
