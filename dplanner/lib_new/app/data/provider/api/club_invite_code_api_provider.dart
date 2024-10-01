import '../../../utils/url_utils.dart';
import '../../model/club/club_invite_code.dart';
import '../../model/common_response.dart';
import 'base_api_provider.dart';

class ClubInviteCodeApiProvider extends BaseApiProvider {
  Future<ClubInviteCode> createClubInviteCode({required int clubId}) async {
    var response = await post("/clubs/$clubId/invite", null) as CommonResponse;
    return ClubInviteCode.fromJson(response.body!.data!);
  }

  Future<ClubInviteCode> findClubIdByInviteCode(
      {required String inviteCode}) async {
    var queryString = UrlUtils.toQueryString({"code": inviteCode});
    var response =
        await get("/clubs/join$queryString") as CommonResponse;
    return ClubInviteCode.fromJson(response.body!.data!);
  }
}
