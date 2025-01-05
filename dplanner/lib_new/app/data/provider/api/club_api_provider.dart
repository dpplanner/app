import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../utils/url_utils.dart';
import '../../model/club/club.dart';
import '../../model/club/request/club_request.dart';
import '../../model/common_response.dart';
import 'support/form_data_factory.dart';
import 'base_api_provider.dart';

class ClubApiProvider extends BaseApiProvider {
  Future<List<Club>> getClubsByMemberId({required int memberId}) async {
    var queryString = UrlUtils.toQueryString({"memberId": memberId});

    var response = await get("/clubs$queryString") as CommonResponse;
    var jsonList = response.body!.data as List<dynamic>;

    return jsonList.map((message) => Club.fromJson(message)).toList();
  }

  Future<Club> createClub({required ClubRequest request}) async {
    var response = await post("/clubs", request.toJson()) as CommonResponse;
    return Club.fromJson(response.body!.data!);
  }

  Future<Club> getClub({required int clubId}) async {
    var response = await get("/clubs/$clubId") as CommonResponse;
    return Club.fromJson(response.body!.data!);
  }

  Future<Club> updateClubInfo(
      {required int clubId, required ClubRequest request}) async {
    var response =
        await patch("/clubs/$clubId", request.toJson()) as CommonResponse;
    return Club.fromJson(response.body!.data!);
  }

  Future<Club> updateClubImage(
      {required int clubId, required XFile image}) async {
    var formData = await FormDataFactory.create({"image": image});
    var response = await post("/clubs/$clubId/update-club-image", formData)
        as CommonResponse;
    return Club.fromJson(response.body!.data!);
  }
}
