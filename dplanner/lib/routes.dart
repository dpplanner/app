import 'package:dplanner/pages/app_setting_page.dart';
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
import 'package:dplanner/pages/error_page.dart';
import 'package:dplanner/pages/login_page.dart';
import 'package:dplanner/pages/my_activity_check_page.dart';
import 'package:dplanner/pages/my_profile_modification_page.dart';

import 'package:dplanner/pages/club_resource_list_page.dart';
import 'package:dplanner/pages/notification_page.dart';
import 'package:dplanner/pages/reservation_list_page.dart';

import 'package:get/get.dart';

final page = [
  /// 로그인 페이지
  GetPage(name: '/', page: () => const LoginPage()),

  /// 클럽 목록
  GetPage(name: '/club_list', page: () => const ClubListPage()),
  GetPage(name: '/club_create1', page: () => const ClubCreatePage()),
  GetPage(name: '/club_create2', page: () => const ClubCreateSuccessPage()),
  GetPage(name: '/club_create3', page: () => const ClubCreateSuccessNextPage()),
  GetPage(name: '/club_join1', page: () => const ClubJoinPage()),
  GetPage(name: '/club_join2', page: () => const ClubJoinNextPage()),
  GetPage(name: '/club_join3', page: () => const ClubJoinSuccessPage()),

  /// 예약 테이블
  GetPage(
      name: '/tab1',
      page: () => const ClubTimetablePage(),
      transition: Transition.noTransition),

  /// 게시글
  GetPage(
      name: '/tab2',
      page: () => const ClubHomePage(),
      transition: Transition.noTransition),
  GetPage(name: '/notification', page: () => const NotificationPage()),
  //PostAddPage()
  //PostPage()

  /// 마이페이지
  GetPage(
      name: '/tab3',
      page: () => const ClubMyPage(),
      transition: Transition.noTransition),
  GetPage(name: '/my_profile', page: () => const MyProfileModificationPage()),
  GetPage(name: '/reservation_list', page: () => const ReservationListPage()),
  GetPage(name: '/my_activity', page: () => const MyActivityCheckPage()),
  GetPage(name: '/club_info', page: () => const ClubInfoPage()),
  GetPage(name: '/club_member_list', page: () => const ClubMemberListPage()),
  GetPage(name: '/resource_list', page: () => const ClubResourceListPage()),
  GetPage(name: '/app_setting', page: () => const AppSettingPage()),
  GetPage(name: '/club_manage', page: () => const ClubManagementPage()),
  GetPage(name: '/club_setting', page: () => const ClubSettingPage()),
  GetPage(name: '/club_manager_list', page: () => const ClubManagerListPage()),

  /// 기타
  GetPage(name: '/error', page: () => const ErrorPage()),
];
