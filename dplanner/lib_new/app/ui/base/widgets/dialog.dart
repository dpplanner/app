import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future dialog({required Widget view, Map<String, dynamic>? arguments}) {
  return Get.dialog(view, routeSettings: RouteSettings(arguments: arguments));
}
