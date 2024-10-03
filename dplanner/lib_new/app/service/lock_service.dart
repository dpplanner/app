import 'package:get/get.dart';

import '../data/model/lock/lock.dart';
import '../data/model/lock/request/lock_create_request.dart';
import '../data/provider/api/lock_api_provider.dart';

class LockService extends GetxService {
  final LockApiProvider lockApiProvider = Get.find<LockApiProvider>();

  Future<List<Lock>> getLocks({required int resourceId}) async {
    return await lockApiProvider.getLocks(resourceId: resourceId);
  }

  Future<Lock> createLock(
      {required int resourceId,
      required DateTime startDateTime,
      required DateTime endDateTime,
      String? message}) async {
    return await lockApiProvider.createLock(
        resourceId: resourceId,
        request: LockRequest.forCreate(
            resourceId: resourceId,
            message: message,
            startDateTime: startDateTime,
            endDateTime: endDateTime));
  }

  Future<Lock> getLock({required int lockId}) async {
    return await lockApiProvider.getLock(lockId: lockId);
  }

  Future<Lock> updateLock({required int lockId, required Lock lock}) async {
    return await lockApiProvider.updateLock(
        lockId: lockId, request: LockRequest.forUpdate(lock: lock));
  }

  Future<void> deleteLock({required int lockId}) async {
    await lockApiProvider.deleteLock(lockId: lockId);
  }
}
