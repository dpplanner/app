import 'package:calendar_view/calendar_view.dart';
import 'package:dplanner/routes.dart';
import 'package:dplanner/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controllers/size.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
