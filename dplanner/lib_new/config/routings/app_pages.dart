import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../app/ui/pages/pages.dart';
import 'routes.dart';

final appPages = [
  GetPage(name: Routes.LOGIN, page: () => LoginPage(), binding: LoginBindings()),
  GetPage(name: Routes.EULA_AGREE, page: () => EulaAgreePage(), binding: EulaAgreeBindings()),
  GetPage(name: Routes.CLUB_LIST, page: () => ClubListPage(), binding: ClubListBindings()),
  GetPage(name: Routes.CLUB_CREATE, page: () => ClubCreatePage(), binding: ClubCreateBindings()),
  GetPage(name: Routes.CLUB_CREATE_SUCCESS, page: () => ClubCreateSuccessPage(), binding: ClubCreateSuccessBindings()),
  GetPage(name: Routes.CLUB_FIND, page: () => ClubFindPage(), binding: ClubFindBindings()),
  GetPage(name: Routes.CLUB_JOIN, page: () => ClubJoinPage(), binding: ClubJoinBindings()),
  GetPage(name: Routes.CLUB_JOIN_SUCCESS, page: () => ClubJoinSuccessPage(), binding: ClubJoinSuccessBindings()),
];
