import 'package:calendar_view/calendar_view.dart';
import 'package:dplanner/routes.dart';
import 'package:dplanner/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/size.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeController = SizeController();
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
