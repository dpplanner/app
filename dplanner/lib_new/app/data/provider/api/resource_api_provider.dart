import '../../model/common_response.dart';
import '../../model/resource/request/resource_request.dart';
import '../../model/resource/resource.dart';
import 'base_api_provider.dart';

class ResourceApiProvider extends BaseApiProvider {

  Future<List<Resource>> getResourcesOfCurrentClub() async {
    var response = await get("/resources") as CommonResponse;
    var jsonList = response.body!.data as List<dynamic>;

    return jsonList.map((json) => Resource.fromJson(json)).toList();
  }

  Future<Resource> createResourceInCurrentClub(
      {required ResourceRequest request}) async {
    var response = await post("/resources", request.toJson()) as CommonResponse;
    return Resource.fromJson(response.body!.data!);
  }

  Future<Resource> getResource({required int resourceId}) async {
    var response = await get("/resources/$resourceId") as CommonResponse;
    return Resource.fromJson(response.body!.data!);
  }

  Future<Resource> updateResource(
      {required int resourceId, required ResourceRequest request}) async {
    var response =
        await put("/resources/$resourceId", request.toJson()) as CommonResponse;
    return Resource.fromJson(response.body!.data!);
  }

  Future<void> deleteResource({required int resourceId}) async {
    await delete("/resources/$resourceId");
  }
}
