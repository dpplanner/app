import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../config/routings/routes.dart';
import '../../../service/club_service.dart';
import '../../../service/member_service.dart';
import 'club_create_validator.dart';

class ClubCreateController extends GetxController {
  final _clubService = Get.find<ClubService>();
  final _memberService = Get.find<MemberService>();

  final clubNameFormKey = GlobalKey<FormState>();
  final clubInfoFormKey = GlobalKey<FormState>();

  final TextEditingController clubNameForm = TextEditingController();
  final TextEditingController clubInfoForm = TextEditingController();

  final ClubCreateValidator validator = ClubCreateValidator();

  var clubNameFormFocused = false.obs;
  var clubInfoFormFocused = false.obs;
  var isComplete = false.obs;

  @override
  void onInit() {
    super.onInit();
    clubNameForm.addListener(() => isComplete.value = clubNameForm.text.isNotEmpty);
  }

  Future<void> createClub() async {
    if (clubNameFormKey.currentState!.validate() && clubInfoFormKey.currentState!.validate()) {
      try {
        var club = await _clubService.createClub(clubName: clubNameForm.text, info: clubInfoForm.text);
        await _memberService.changeClub(clubId: club.id);
        Get.offNamed(Routes.CLUB_CREATE_SUCCESS, arguments: {"club": club});
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void back() {
    Get.back();
  }
}
