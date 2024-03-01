import 'package:get/get.dart';
import '../models/club_member_model.dart';

class MemberController extends GetxController {
  static MemberController get to => Get.find();

  Rx<ClubMemberModel> clubMember =
      ClubMemberModel(id: 0, name: '', role: '').obs;
}
