import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../config/routings/routes.dart';
import '../../../data/model/club/club.dart';
import '../../../service/club_member_service.dart';
import 'club_join_validator.dart';

class ClubJoinController extends GetxController {
  final Club club = Get.arguments["club"];

  final _clubMemberService = Get.find<ClubMemberService>();

  final clubMemberNameFormKey = GlobalKey<FormState>();
  final clubMemberInfoFormKey = GlobalKey<FormState>();

  final TextEditingController clubMemberNameForm = TextEditingController();
  final TextEditingController clubMemberInfoForm = TextEditingController();

  final ClubJoinValidator validator = ClubJoinValidator();

  var clubMemberNameFormFocused = false.obs;
  var clubMemberInfoFormFocused = false.obs;
  var isComplete = false.obs;

  @override
  void onInit() {
    super.onInit();
    clubMemberNameForm.addListener(() => isComplete.value = clubMemberNameForm.text.isNotEmpty);
  }

  Future<void> joinClub() async {
    if (clubMemberNameFormKey.currentState!.validate() &&
        clubMemberInfoFormKey.currentState!.validate()) {
      try {
        var clubMember = await _clubMemberService.joinClub(
            clubId: club.id, name: clubMemberNameForm.text, info: clubMemberInfoForm.text);
        print(clubMember.name);
        Get.offAllNamed(Routes.CLUB_JOIN_SUCCESS);
      } catch (e) {
        snackBar(title: "클럽 가입 신청에 실패했습니다.", content: "잠시 후 다시 시도해 주세요");
        print(e.toString());
      }
    }
  }
}
