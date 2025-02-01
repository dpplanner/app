import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../config/routings/routes.dart';
import '../../../service/services.dart';
import '../../base/pages/simple_info_page.dart';

class EulaAgreeController extends GetxController {
  final _memberService = Get.find<MemberService>();

  void toServiceTermInfoPage() async {
    Get.to(SimpleInfoPage(title: "서비스 이용약관", info: await _loadServiceTermInfo()));
  }

  Future<void> agreeEula() async {
    await _memberService.agreeEula();
    Get.offAllNamed(Routes.CLUB_LIST);
  }

  void backToLoginPage() {
    Get.back();
    snackBar(title: "서비스 이용 약관에 동의하지 않았습니다", content: "로그인 페이지로 돌아갑니다");
  }

  Future<String> _loadServiceTermInfo() async {
    return await rootBundle.loadString("assets/texts/service_term_info.txt");
  }
}
