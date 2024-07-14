import 'dart:convert';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/routes.dart';
import 'package:dplanner/const/style.dart';
import 'package:dplanner/services/club_api_service.dart';
import 'package:dplanner/services/club_member_api_service.dart';
import 'package:dplanner/services/token_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'const/const.dart';
import 'controllers/club.dart';
import 'controllers/posts.dart';
import 'controllers/size.dart';

import 'package:firebase_core/firebase_core.dart';
import 'decode_token.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin _localNotification = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await _initAppTrackingPlugin();

  MobileAds.instance.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _initLocalNotification();

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

  // 앱이 켜진 상태에서 사용자가 알림이 왔을 때 -> 로컬 푸시알림 전송
  FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
    if (message == null) return;
    if (message.notification == null) return;

    NotificationDetails details = const NotificationDetails(
        iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true
        ),
        android: AndroidNotificationDetails(
            "com.dancepozz.dplanner",
            "dplanner",
            importance: Importance.max,
            priority: Priority.high
        )
    );

    await _localNotification.show(
      message.hashCode,
      message.notification!.title,
      message.notification!.body,
      details,
      payload: jsonEncode(message.data)
    );
  });

  // 백그라운드 상태에서 사용자가 알림을 클릭했을 때 처리
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) => _handleFirebaseNotification(message));
  // 앱이 완전히 종료된 상태에서 알림을 클릭했을 때 처리
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) => _handleFirebaseNotification(message));

  KakaoSdk.init(nativeAppKey: '2b20483f38041a509dfaab39ab801eb0');
  runApp(const MyApp());
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

Future<void> _initAppTrackingPlugin() async {
  try {
    final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 200));
      final TrackingStatus status = await AppTrackingTransparency.requestTrackingAuthorization();
    }
  } on PlatformException {
    print("transparency setting fail");
  }
  final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
}

Future<void> _initLocalNotification() async {
  AndroidInitializationSettings android = const AndroidInitializationSettings("@mipmap/dplanner_logo");
  DarwinInitializationSettings ios = const DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );

  InitializationSettings settings = InitializationSettings(android: android, iOS: ios);

  await _localNotification.initialize(
      settings,
      onDidReceiveNotificationResponse: _handleLocalNotification,
      onDidReceiveBackgroundNotificationResponse: _handleLocalNotification
  );
}

void _handleLocalNotification(NotificationResponse details) async {
      if (details.payload == null) return;
      Map<String, dynamic> data = jsonDecode(details.payload!);

      await _handleNotificationData(data);
  }

Future<void> _handleFirebaseNotification(RemoteMessage? message) async {
  if (message == null) return;
  Map<String, dynamic> data = message.data;

  await _handleNotificationData(data);
}

Future<void> _handleNotificationData(Map<String, dynamic> data) async {
  Get.offAllNamed("/club_list");

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
    Get.offAllNamed('/tab2', arguments: 1);
  }

  if (data.containsKey("id") && data["id"] != null) {
    // 알림센터 진입
    Get.toNamed("/notification", parameters: {"id": data["id"]}, arguments: 1);
  }
}
