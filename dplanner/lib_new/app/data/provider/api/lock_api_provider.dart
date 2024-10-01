import '../../model/common_response.dart';
import '../../model/lock/lock.dart';
import '../../model/lock/request/lock_create_request.dart';
import 'base_api_provider.dart';

class LockApiProvider extends BaseApiProvider {
  Future<List<Lock>> getLocks({required int resourceId}) async {
    var response = await get("/locks/resources/$resourceId") as CommonResponse;
    var jsonList = response.body!.data as List<dynamic>;

    return jsonList.map((message) => Lock.fromJson(message)).toList();
  }

  Future<Lock> createLock(
      {required int resourceId, required LockRequest request}) async {
    var response = await post("/locks/resources/$resourceId", request.toJson())
        as CommonResponse;

    return Lock.fromJson(response.body!.data!);
  }

  Future<Lock> getLock({required int lockId}) async {
    var response = await get("/locks/$lockId") as CommonResponse;
    return Lock.fromJson(response.body!.data!);
  }

  Future<Lock> updateLock(
      {required int lockId, required LockRequest request}) async {
    var response =
        await put("/locks/$lockId", request.toJson()) as CommonResponse;
    return Lock.fromJson(response.body!.data!);
  }

  void deleteLock({required int lockId}) async {
    await delete("/locks/$lockId");
  }
}
