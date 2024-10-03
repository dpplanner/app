import 'package:get/get.dart';

import '../data/model/resource/request/resource_request.dart';
import '../data/model/resource/resource.dart';
import '../data/model/resource/resource_type.dart';
import '../data/provider/api/resource_api_provider.dart';

class ResourceService extends GetxService {
  final ResourceApiProvider resourceApiProvider =
      Get.find<ResourceApiProvider>();

  Future<List<Resource>> getResourcesOfCurrentClub() async {
    return await resourceApiProvider.getResourcesOfCurrentClub();
  }

  Future<Resource> createResource(
      {required int clubId,
      required String name,
      required ResourceType resourceType,
      required String info,
      int bookableSpan = 7,
      String? notice,
      bool returnMessageRequired = false}) async {
    return await resourceApiProvider.createResourceInCurrentClub(
        request: ResourceRequest.forCreate(
            clubId: clubId,
            name: name,
            info: info,
            returnMessageRequired: returnMessageRequired,
            resourceType: resourceType,
            notice: notice,
            bookableSpan: bookableSpan));
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

  Future<void> deleteResource({required int resourceId}) async {
    await resourceApiProvider.deleteResource(resourceId: resourceId);
  }
}
