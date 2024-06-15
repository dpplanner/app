import 'package:calendar_view/calendar_view.dart';
import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/routes.dart';
import 'package:dplanner/const/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/club.dart';
import 'controllers/posts.dart';
import 'controllers/size.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Got a message whilst in the foreground!");
    print("Message data: ${message.data}");

    if (message.notification != null) {
      print(
          'Message also contained a notification: ${message.notification!.body}');
    }
  });

// 백그라운드 상태에서 사용자가 알림을 클릭했을 때 처리
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("A message was opened: ${message.data}");
    // 여기서는 예를 들어, 특정 화면으로 이동하는 등의 처리를 할 수 있습니다.
  });

// 앱이 완전히 종료된 상태에서 알림을 클릭했을 때의 초기 메시지 처리
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print("The app was opened from a terminated state: ${message.data}");
      // 필요한 처리 수행, 예: 특정 페이지로 이동
    }
  });

  KakaoSdk.init(nativeAppKey: '32f8bf31b072c577a63d09db9d16ab5d');

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
