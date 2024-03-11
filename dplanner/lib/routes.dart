import 'package:dplanner/pages/club_create_page.dart';
import 'package:dplanner/pages/club_create_success_next_page.dart';
import 'package:dplanner/pages/club_create_success_page.dart';
import 'package:dplanner/pages/club_home_page.dart';
import 'package:dplanner/pages/club_info_page.dart';
import 'package:dplanner/pages/club_join_next_page.dart';
import 'package:dplanner/pages/club_join_page.dart';
import 'package:dplanner/pages/club_join_success_page.dart';
import 'package:dplanner/pages/club_list_page.dart';
import 'package:dplanner/pages/club_management_page.dart';
import 'package:dplanner/pages/club_manager_list_page.dart';
import 'package:dplanner/pages/club_member_list_page.dart';
import 'package:dplanner/pages/club_my_page.dart';
import 'package:dplanner/pages/club_setting_page.dart';
import 'package:dplanner/pages/club_timetable_page.dart';
import 'package:dplanner/pages/login_page.dart';
import 'package:dplanner/pages/my_profile_modification_page.dart';

import 'package:dplanner/pages/club_resource_list_page.dart';

import 'package:get/get.dart';

final page = [
  GetPage(name: '/', page: () => const LoginPage()),
  GetPage(name: '/club_list', page: () => const ClubListPage()),
  GetPage(name: '/club_create', page: () => const ClubCreatePage()),
  GetPage(
      name: '/club_create_success', page: () => const ClubCreateSuccessPage()),
  GetPage(
      name: '/club_create_success_next',
      page: () => const ClubCreateSuccessNextPage()),
  GetPage(name: '/club_join', page: () => const ClubJoinPage()),
  GetPage(name: '/club_join_next', page: () => const ClubJoinNextPage()),
  GetPage(name: '/club_join_success', page: () => const ClubJoinSuccessPage()),
  GetPage(
      name: '/tab1',
      page: () => const ClubTimetablePage(),
      transition: Transition.noTransition),
  GetPage(
      name: '/tab2',
      page: () => const ClubHomePage(),
      transition: Transition.noTransition),
  GetPage(
      name: '/tab3',
      page: () => const ClubMyPage(),
      transition: Transition.noTransition),
  GetPage(name: '/profile', page: () => const MyProfileModificationPage()),
  GetPage(name: '/club_info', page: () => const ClubInfoPage()),
  GetPage(name: '/club_member_list', page: () => const ClubMemberListPage()),
  GetPage(name: '/resource_list', page: () => const ClubResourceListPage()),
  GetPage(name: '/manager_list', page: () => const ClubManagerListPage()),
  GetPage(name: '/club_manage', page: () => const ClubManagementPage()),
  GetPage(name: '/club_setting', page: () => const ClubSettingPage()),
];
