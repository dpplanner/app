import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../data/model/member/request/fcm_token_refresh_request.dart';
import '../data/provider/api/member_api_provider.dart';
import 'member_service.dart';

class FirebaseMessagingService extends GetxService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final MemberApiProvider memberApiProvider = Get.find<MemberApiProvider>();
  final MemberService memberService = Get.find<MemberService>();

  Future<void> refreshFcmToken() async {
    int memberId = await memberService.getMemberId();

    await _requestPermission();
    var fcmToken = await firebaseMessaging.getToken();

    var request = FcmTokenRefreshRequest(fcmToken: fcmToken!);
    await memberApiProvider.refreshFcmToken(
        memberId: memberId, request: request);
  }

  /*
   * private method
   */
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
