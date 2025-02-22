import 'package:get/get.dart';

import '../../../../config/routings/routes.dart';
import '../../../data/model/club/club.dart';

class ClubJoinSuccessController extends GetxController {
  final Club club = Get.arguments["club"];

  void toClubListPage() {
    Get.offAllNamed(Routes.CLUB_LIST);
  }
}
