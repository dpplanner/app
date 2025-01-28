import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'config/bindings/app_binings.dart';
import 'config/routings/app_pages.dart';
import 'config/routings/routes.dart';
import 'config/themes/app_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus(); // 키보드 닫기 이벤트
        },
        child: CalendarControllerProvider(
            controller: EventController(),
            child: GetMaterialApp(
              title: 'DPlanner',
              theme: AppTheme.lightTheme,
              debugShowCheckedModeBanner: false,
              initialRoute: Routes.LOGIN,
              getPages: appPages,
              initialBinding: AppBindings(),
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
        )
    );
  }
}
