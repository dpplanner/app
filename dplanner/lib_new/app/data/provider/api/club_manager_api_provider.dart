import '../../model/club/club_manager.dart';
import '../../model/club/request/club_manager_request.dart';
import '../../model/common_response.dart';
import 'base_api_provider.dart';

class ClubManagerApiProvider extends BaseApiProvider {
  Future<List<ClubManager>> getClubManagersByClubId(
      {required int clubId}) async {
    var response = await get("/clubs/$clubId/authorities") as CommonResponse;
    var jsonList = response.body!.data as List<dynamic>;

    return jsonList.map((message) => ClubManager.fromJson(message)).toList();
  }

  Future<ClubManager> createClubManager(
      {required int clubId, required ClubManagerRequest request}) async {
    var response = await post("/clubs/$clubId/authorities", request.toJson())
        as CommonResponse;
    return ClubManager.fromJson(response.body!.data!);
  }

  Future<ClubManager> updateClubManager(
      {required int clubId, required ClubManagerRequest request}) async {
    var response = await put("/clubs/$clubId/authorities", request.toJson())
        as CommonResponse;
    return ClubManager.fromJson(response.body!.data!);
  }

  Future<void> deleteClubManager(
      {required int clubId, required ClubManagerRequest request}) async {
    await deleteWithBody("/clubs/$clubId/authorities", request.toJson());
  }
}
