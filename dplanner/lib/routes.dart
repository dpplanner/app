import 'package:dplanner/club_root_page.dart';
import 'package:dplanner/pages/club_create_page.dart';
import 'package:dplanner/pages/club_create_success_next_page.dart';
import 'package:dplanner/pages/club_create_success_page.dart';
import 'package:dplanner/pages/club_home_page.dart';
import 'package:dplanner/pages/club_list_page.dart';
import 'package:dplanner/pages/club_my_page.dart';
import 'package:dplanner/pages/club_timetable_page.dart';
import 'package:dplanner/pages/login_page.dart';
import 'package:get/get.dart';

final page = [
  GetPage(name: '/', page: () => const LoginPage()),
  GetPage(name: '/club_list', page: () => const ClubListPage()),
  GetPage(name: '/club_create', page: () => const ClubCreatePage()),
  GetPage(
      name: '/club_create_success', page: () => const ClubCreateSuccessPage()),
  GetPage(
      name: '/club_create_success_next',
      page: () => const ClubCreateSuccessNext()),
  GetPage(name: '/club_root', page: () => const ClubRootPage()),
  GetPage(name: '/tab1', page: () => const ClubTimetablePage()),
  GetPage(name: '/tab2', page: () => const ClubHomePage()),
  GetPage(name: '/tab3', page: () => const ClubMyPage())
];
