import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../app/ui/pages/club_create/club_create_bindings.dart';
import '../../app/ui/pages/club_create/club_create_page.dart';
import '../../app/ui/pages/club_create_success/club_create_success_bindings.dart';
import '../../app/ui/pages/club_create_success/club_create_success_page.dart';
import '../../app/ui/pages/club_find/club_find_bindings.dart';
import '../../app/ui/pages/club_find/club_find_page.dart';
import '../../app/ui/pages/club_list/club_list_bindings.dart';
import '../../app/ui/pages/club_list/club_list_page.dart';
import '../../app/ui/pages/eula_agree/eula_agree_bindings.dart';
import '../../app/ui/pages/eula_agree/eula_agree_page.dart';
import '../../app/ui/pages/login/login_bindings.dart';
import '../../app/ui/pages/login/login_page.dart';
import 'routes.dart';

final appPages = [
  GetPage(name: Routes.LOGIN, page: () => LoginPage(), binding: LoginBindings()),
  GetPage(name: Routes.EULA_AGREE, page: () => EulaAgreePage(), binding: EulaAgreeBindings()),
  GetPage(name: Routes.CLUB_LIST, page: () => ClubListPage(), binding: ClubListBindings()),
  GetPage(name: Routes.CLUB_CREATE, page: () => ClubCreatePage(), binding: ClubCreateBindings()),
  GetPage(name: Routes.CLUB_CREATE_SUCCESS, page: () => ClubCreateSuccessPage(), binding: ClubCreateSuccessBindings()),
  GetPage(name: Routes.CLUB_FIND, page: () => ClubFindPage(), binding: ClubFindBindings()),
];
