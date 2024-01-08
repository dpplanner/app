import 'package:dplanner/routes.dart';
import 'package:dplanner/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DPlanner',
      theme: ThemeData(
        primaryColor: AppColor.objectColor,
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: page,
    );
  }
}
