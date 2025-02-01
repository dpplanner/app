import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../config/routings/routes.dart';
import '../../../data/model/club/club.dart';
import '../../../service/club_service.dart';
import '../../base/types/active_tab.dart';
import '../../base/widgets/snackbar.dart';

class ClubCreateSuccessController extends GetxController {
  final _clubService = Get.find<ClubService>();

  Club club = Get.arguments["club"];

  void copyInviteCode() async {
    try {
      var response = await _clubService.createInviteCode(clubId: club.id);
      Clipboard.setData(ClipboardData(text: response.inviteCode));
      snackBar(title: "초대코드가 복사되었습니다", content: "클럽에 초대할 사람에게 공유해주세요");
    } catch (e) {
      print(e.toString());
      snackBar(title: "초대코드를 복사하지 못했습니다", content: "잠시 후 다시 시도해 주세요");
    }
  }

  void toPostListPage() {
    Get.offAllNamed(Routes.POST_LIST, parameters: ActiveTab.HOME.toParam());
  }
}