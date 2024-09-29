import 'package:get/get.dart';

import '../data/model/resource/request/resource_request.dart';
import '../data/model/resource/resource.dart';
import '../data/provider/api/resource_api_provider.dart';

class ResourceService extends GetxService {
  final ResourceApiProvider resourceApiProvider =
      Get.find<ResourceApiProvider>();

  Future<List<Resource>> getResourcesOfCurrentClub() async {
    return await resourceApiProvider.getResourcesOfCurrentClub();
  }

  Future<Resource> createResource({required Resource resource}) async {
    return await resourceApiProvider.createResourceInCurrentClub(
        request: ResourceRequest.forCreate(resource: resource));
  }

  Future<Resource> getResource({required int resourceId}) async {
    return await resourceApiProvider.getResource(resourceId: resourceId);
  }

  Future<Resource> updateResource(
      {required int resourceId, required Resource resource}) async {
    return await resourceApiProvider.updateResource(
        resourceId: resourceId,
        request: ResourceRequest.forUpdate(resource: resource));
  }

  void deleteResource({required int resourceId}) async {
    return resourceApiProvider.deleteResource(resourceId: resourceId);
  }
}
