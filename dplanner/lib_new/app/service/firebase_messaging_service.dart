import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../data/model/member/request/fcm_token_refresh_request.dart';
import '../data/provider/api/member_api_provider.dart';
import '../utils/token_utils.dart';
import 'secure_storage_service.dart';

class FirebaseMessagingService extends GetxService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final MemberApiProvider memberApiProvider = Get.find<MemberApiProvider>();
  final SecureStorageService secureStorageService =
      Get.find<SecureStorageService>();

  void refreshFcmToken() async {
    int memberId = await _getMemberId();

    await _requestPermission();
    var fcmToken = await firebaseMessaging.getToken();

    var request = FcmTokenRefreshRequest(fcmToken: fcmToken!);
    await memberApiProvider.refreshFcmToken(
        memberId: memberId, request: request);
  }

  /*
  * private methods
  */
  Future<int> _getMemberId() async {
    String? accessToken = await secureStorageService.getAccessToken();
    return TokenUtils.getMemberId(accessToken: accessToken!);
  }

  Future<void> _requestPermission() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}
