import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';

import '../../model/club/club.dart';
import '../../model/club/request/club_request.dart';
import '../../model/common_response.dart';
import 'base_api_provider.dart';

class ClubApiProvider extends BaseApiProvider {
  Future<List<Club>> getClubsByMemberId({required int memberId}) async {
    var response =
        await get("/clubs", query: {"memberId": memberId}) as CommonResponse;
    var jsonList = response.data as List<Map<String, dynamic>>;

    return jsonList.map((message) => Club.fromJson(message)).toList();
  }

  Future<Club> createClub({required ClubRequest request}) async {
    var response = await post("/clubs", request.toJson()) as CommonResponse;
    return Club.fromJson(response.data);
  }

  Future<Club> getClub({required int clubId}) async {
    var response = await get("/clubs/$clubId") as CommonResponse;
    return Club.fromJson(response.data);
  }

  Future<Club> updateClubInfo(
      {required int clubId, required ClubRequest request}) async {
    var response =
        await patch("/clubs/$clubId", request.toJson()) as CommonResponse;
    return Club.fromJson(response.data);
  }

  Future<Club> updateClubImage(
      {required int clubId, required XFile image}) async {
    var formData =
        FormData({"file": MultipartFile(image, filename: image.name)});

    var response = await post("/clubs/$clubId/update-club-image", formData)
        as CommonResponse;
    return Club.fromJson(response.data);
  }
}
