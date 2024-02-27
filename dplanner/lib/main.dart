import 'package:calendar_view/calendar_view.dart';
import 'package:dplanner/controllers/login.dart';
import 'package:dplanner/routes.dart';
import 'package:dplanner/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/size.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  KakaoSdk.init(nativeAppKey: '32f8bf31b072c577a63d09db9d16ab5d');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeController = SizeController();
    final loginController = LoginController();
    sizeController.screenWidth = MediaQuery.of(context).size.width;
    sizeController.screenHeight = MediaQuery.of(context).size.height;
    return CalendarControllerProvider(
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
          Get.put(loginController);
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
    );
  }
}
