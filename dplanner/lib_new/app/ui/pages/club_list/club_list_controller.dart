import 'package:get/get.dart';

import '../../../../config/routings/routes.dart';
import '../../../data/model/club/club.dart';
import '../../../service/services.dart';
import '../../base/types/active_tab.dart';
import '../../base/widgets/snackbar.dart';

class ClubListController extends GetxController {
  final ClubService _clubService = Get.find<ClubService>();
  final MemberService _memberService = Get.find<MemberService>();

  RxList<Club> clubs = <Club>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getMyClubList();
  }

  Future<void> getMyClubList() async {
    clubs.value = await _clubService.getMyClubs();
  }

  Future<void> enterToClub(Club club) async {
    if (club.isConfirmed ?? false) {
      try {
        await _memberService.changeClub(clubId: club.id);
        Get.toNamed(Routes.POST_LIST, arguments: ActiveTab.HOME);
      } catch (e) {
        print(e.toString());
      }
    } else {
      snackBar(title: "해당 클럽에 가입 진행 중입니다.", content: "가입 후에 눌러주세요.");
    }
  }

  void toAppSettingPage() {
    Get.toNamed(Routes.APP_SETTING_MENU);
  }

  void toClubFindPage() {
    Get.toNamed(Routes.CLUB_FIND);
  }

  void toClubCreatePage() {
    Get.toNamed(Routes.CLUB_CREATE);
  }
}