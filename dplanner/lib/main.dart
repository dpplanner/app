import 'package:calendar_view/calendar_view.dart';
import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/routes.dart';
import 'package:dplanner/const/style.dart';
import 'package:dplanner/services/club_api_service.dart';
import 'package:dplanner/services/club_member_api_service.dart';
import 'package:dplanner/services/token_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'const/const.dart';
import 'controllers/club.dart';
import 'controllers/posts.dart';
import 'controllers/size.dart';

import 'package:firebase_core/firebase_core.dart';
import 'decode_token.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings notificationSettings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );

  print("User granted permissions:${notificationSettings.authorizationStatus}");

  // 앱이 켜진 상태에서 사용자가 알림을 클릭했을 때 처리
  FirebaseMessaging.onMessage.listen((RemoteMessage? message) => _handleFirebaseMessage(message));

  // 백그라운드 상태에서 사용자가 알림을 클릭했을 때 처리
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) => _handleFirebaseMessage(message));

  // 앱이 완전히 종료된 상태에서 알림을 클릭했을 때 처리
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) => _handleFirebaseMessage(message));

  KakaoSdk.init(nativeAppKey: '32f8bf31b072c577a63d09db9d16ab5d');

  runApp(const MyApp());
}

Future<void> _handleFirebaseMessage(RemoteMessage? message) async {
  if (message == null) return;
  Map<String, dynamic> data = message.data;
  print(data);

  if (data.containsKey("clubId") && data["clubId"] != null) {
    // recentClub 갱신
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: accessTokenKey);
    await TokenApiService.patchUpdateClub(
        memberId: decodeToken(accessToken!)['sub'],
        clubId: data["clubId"]
    );

    String? updatedAccessToken = await storage.read(key: accessTokenKey);
    ClubController.to.club.value = await ClubApiService.getClub(
        clubID: decodeToken(updatedAccessToken!)['recent_club_id']
    );

    MemberController.to.clubMember.value = await ClubMemberApiService.getClubMember(
        clubId: decodeToken(updatedAccessToken)['recent_club_id'],
        clubMemberId: decodeToken(updatedAccessToken)['club_member_id']
    );

    // 클럽 홈 진입(스택 쌓기용)
    Get.toNamed('/tab2', arguments: 1);
  }

  if (data.containsKey("id") && data["id"] != null) {
    // 알림센터 진입
    Get.toNamed("/notification", parameters: {"id": data["id"]});
  }

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeController = SizeController();
    final clubController = ClubController();
    final memberController = MemberController();
    final postController = PostController();
    sizeController.screenWidth = MediaQuery.of(context).size.width;
    sizeController.screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus(); // 키보드 닫기 이벤트
      },
      child: CalendarControllerProvider(
        controller: EventController(),
        child: GetMaterialApp(
          title: 'DPlanner',
          theme: ThemeData(
              primaryColor: AppColor.objectColor,
              fontFamily: 'Pretendard',
              useMaterial3: true),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          getPages: page,
          initialBinding: BindingsBuilder(() {
            Get.put(sizeController);
            Get.put(clubController);
            Get.put(memberController);
            Get.put(postController);
          }),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ko', ''),
            Locale('en', ''),
          ],
        ),
      ),
    );
  }
}
