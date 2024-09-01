import 'package:get/get.dart';

import '../../app/service/auth/secure_storage_service.dart';

class StorageDependency {
  static void init() {
    Get.putAsync<SecureStorageService>(() async => SecureStorageService(), permanent: true);
  }
}