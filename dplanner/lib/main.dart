import 'dart:convert';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/routes.dart';
import 'package:dplanner/const/style.dart';
import 'package:dplanner/services/club_api_service.dart';
import 'package:dplanner/services/club_member_api_service.dart';
import 'package:dplanner/services/token_api_service.dart';
import 'package:flutter/foundation.dart';
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
import 'widgets/reset_deep_link.dart';
import 'controllers/club.dart';
import 'controllers/posts.dart';
import 'controllers/size.dart';

import 'package:firebase_core/firebase_core.dart';
import 'decode_token.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin _localNotification = FlutterLocalNotificationsPlugin();

/// 웹은 폰트 weight를 화면에서 처음 쓸 때 lazy 로드해서 한글이 □로 깨졌다가
/// 정상으로 바뀐다. 자주 쓰는 weight를 미리 로드해두고 첫 프레임을 그린다.
/// (로딩 동안은 index.html 스플래시가 가려줌)
Future<void> _preloadWebFonts() async {
  if (!kIsWeb) return;
  final fontLoader = FontLoader('Pretendard');
  const paths = [
    'assets/fonts/Pretendard-Thin.ttf',
    'assets/fonts/Pretendard-ExtraLight.ttf',
    'assets/fonts/Pretendard-Light.ttf',
    'assets/fonts/Pretendard-Regular.ttf',
    'assets/fonts/Pretendard-Medium.ttf',
    'assets/fonts/Pretendard-SemiBold.ttf',
    'assets/fonts/Pretendard-Bold.ttf',
    'assets/fonts/Pretendard-ExtraBold.ttf',
    'assets/fonts/Pretendard-Black.ttf',
  ];
  for (final p in paths) {
    fontLoader.addFont(rootBundle.load(p));
  }
  await fontLoader.load();
}

Future<void> main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // 웹: 내부 라우트로 새로고침 시 상태 미로딩 크래시 방지 위해 루트에서 시작
  resetDeepLinkToRoot();

  await _preloadWebFonts();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // 웹은 flutter_native_splash 설정(dart run flutter_native_splash:create)이 없어
  // preserve/remove가 예외를 던지므로 모바일에서만 사용
  if (!kIsWeb) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }

  // 모바일 전용: 앱 추적 권한 + AdMob (웹 미지원)
  if (!kIsWeb) {
    await _initAppTrackingPlugin();
    MobileAds.instance.initialize();
  }

  // 모바일 전용: Firebase + 로컬 알림 + FCM 푸시 처리
  // (웹은 Firebase web 설정/Web Push 미구현 상태라 통째로 비활성화.
  //  추후 Web Push 대응 시 flutterfire configure로 web 옵션 등록 후 활성화)
  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await _initLocalNotification();

    await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true
    );

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
  }

  KakaoSdk.init(
    nativeAppKey: '2b20483f38041a509dfaab39ab801eb0',
    javaScriptAppKey: '13226a0e3bb2c76b8342a03f0df7c64d', // 웹 카카오 로그인용 JS 키
  );
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
          // 웹/데스크톱 등 넓은 화면에서는 모바일 폭(최대 480)으로 가운데 정렬.
          // 제약된 폭을 SizeController와 MediaQuery 양쪽에 반영해
          // screenWidth 기반 레이아웃이 정상 비율로 보이게 한다.
          builder: (context, child) {
            const maxWidth = 480.0;
            final mq = MediaQuery.of(context);
            final isWide = mq.size.width > maxWidth;
            final appWidth = isWide ? maxWidth : mq.size.width;

            sizeController.screenWidth = appWidth;
            sizeController.screenHeight = mq.size.height;

            if (!isWide) return child!;

            return ColoredBox(
              color: const Color(0xFFE9E9EC), // 양옆 레터박스 배경
              child: Center(
                child: ClipRect(
                  child: SizedBox(
                    width: maxWidth,
                    child: MediaQuery(
                      data: mq.copyWith(size: Size(maxWidth, mq.size.height)),
                      child: child!,
                    ),
                  ),
                ),
              ),
            );
          },
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

void _handleFirebaseNotification(RemoteMessage? message) {
  if (message == null) return;
  Map<String, dynamic> data = message.data;

  WidgetsBinding.instance.addPostFrameCallback((_) => _handleNotificationData(data));
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
