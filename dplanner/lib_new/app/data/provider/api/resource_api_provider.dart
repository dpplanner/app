import '../../model/common_response.dart';
import '../../model/resource/request/resource_create_request.dart';
import '../../model/resource/resource.dart';
import 'base_api_provider.dart';

class ResourceApiProvider extends BaseApiProvider {

  Future<List<Resource>> getResourcesOfCurrentClub() async {
    var response = get("/resources") as CommonResponse;
    var jsonList = response.data as List<Map<String, dynamic>>;

    return jsonList.map((json) => Resource.fromJson(json)).toList();
  }

  Future<Resource> createResourceInCurrentClub(
      {required ResourceCreateRequest request}) async {
    var response = await post("/resources", request.toJson()) as CommonResponse;
    return Resource.fromJson(response.data);
  }

  Future<Resource> getResource({required int resourceId}) async {
    var response = await get("/resources/$resourceId") as CommonResponse;
    return Resource.fromJson(response.data);
  }

  Future<Resource> updateResource(
      {required int resourceId, required Resource request}) async {
    var response =
        await put("/resources/$resourceId", request.toJson()) as CommonResponse;
    return Resource.fromJson(response.data);
  }

  void deleteResource({required int resourceId}) async {
    await delete("/resources/$resourceId");
  }
}
