import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../app/ui/pages/club_list/club_list_bindings.dart';
import '../../app/ui/pages/club_list/club_list_page.dart';
import '../../app/ui/pages/login/login_bindings.dart';
import '../../app/ui/pages/login/login_page.dart';
import 'routes.dart';

final appPages = [
  GetPage(name: Routes.LOGIN, page: () => LoginPage(), binding: LoginBindings()),
  GetPage(name: Routes.CLUB_LIST, page: () => ClubListPage(), binding: ClubListBindings())
];
