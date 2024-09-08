import '../../model/member/request/club_change_request.dart';
import '../../model/member/request/fcm_token_refresh_request.dart';
import 'base_api_provider.dart';

class MemberApiProvider extends BaseApiProvider {

  Future<void> postEula() async {
    await post('/eula', null);
  }

  Future<void> refreshFcmToken(
      {required int memberId, required FcmTokenRefreshRequest request}) async {
    await patch('/members/$memberId/refresh-fcmtoken', request.toJson());
  }

  Future<void> changeClub(
      {required int memberId, required ClubChangeRequest request}) async {
    await patch('/members/$memberId/change-club', request.toJson());
  }

  Future<void> deleteMember({required int memberId}) async {
    await delete('/members/$memberId');
  }
}
