import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../config/routings/routes.dart';
import '../../../base/exceptions.dart';
import '../../../data/model/club/club.dart';
import '../../../service/club_service.dart';
import 'club_find_validator.dart';

class ClubFindController extends GetxController {
  final _clubService = Get.find<ClubService>();

  Rxn<Club> club = Rxn<Club>();

  final clubInviteCodeFormKey = GlobalKey<FormState>();
  final TextEditingController clubInviteCodeForm = TextEditingController();

  final ClubFindValidator validator = ClubFindValidator();

  var clubInviteCodeFormFocused = false.obs;
  var clubInviteCodeSubmitted = false.obs;
  var isComplete = false.obs;

  @override
  void onInit() {
    super.onInit();
    clubInviteCodeForm.addListener(() => isComplete.value = clubInviteCodeForm.text.isNotEmpty);
  }

  Future<void> findClubByInviteCode() async {
    if (clubInviteCodeFormKey.currentState!.validate()) {
      try {
        var clubId = await _clubService.findClubIdByInviteCode(inviteCode: clubInviteCodeForm.text);
        Club? foundClub = await _clubService.getClub(clubId: clubId);
        club.value = foundClub;
      } on ClubNotFoundException {
        club.value = null;
      } catch(e) {
        snackBar(title: "클럽 조회에 실패했습니다", content: "잠시 후 다시 시도해 주세요");
        print(e.toString());
      } finally {
        clubInviteCodeSubmitted.value = true;
      }
    }
  }

  Future<void> toJoinClubPage() async {
    try {
      var myClubs = await _clubService.getMyClubs();
      if (myClubs.any((myClub) => myClub.id == club.value?.id)) {
        snackBar(title: "해당 클럽에 이미 참여 중입니다.", content: "다른 클럽 초대코드를 입력해주세요");
      } else {
        Get.toNamed(Routes.CLUB_JOIN, arguments: {"club": club.value});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void clearForm() {
    clubInviteCodeSubmitted.value = false;
  }
}
