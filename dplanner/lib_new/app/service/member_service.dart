import 'package:get/get.dart';

import '../data/model/member/request/club_change_request.dart';
import '../data/provider/api/member_api_provider.dart';
import '../utils/token_utils.dart';
import 'secure_storage_service.dart';
import 'token_service.dart';

class MemberService extends GetxService {

  final TokenService tokenService = Get.find<TokenService>();
  final MemberApiProvider memberApiProvider = Get.find<MemberApiProvider>();
  final SecureStorageService secureStorageService = Get.find<SecureStorageService>();

  void postEula() {
    memberApiProvider.postEula();
  }

  void changeClub ({required int clubId}) async {
    int memberId = await _getMemberId();
    var request = ClubChangeRequest(clubId: clubId);
    await memberApiProvider.changeClub(memberId: memberId, request: request);
    tokenService.refreshToken();
  }

  void quit() async {
    int memberId = await _getMemberId();
    await memberApiProvider.deleteMember(memberId: memberId);
    await secureStorageService.deleteAll();
  }

  /*
  * private methods
  */
  Future<int> _getMemberId() async {
    String? accessToken = await secureStorageService.getAccessToken();
    return TokenUtils.getMemberId(accessToken: accessToken!);
  }
}