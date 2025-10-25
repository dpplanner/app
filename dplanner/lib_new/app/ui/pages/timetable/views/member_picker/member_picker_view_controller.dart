import 'package:get/get.dart';

import '../../../../../data/model/club/club_member.dart';
import '../../../../../service/club_member_service.dart';
import '../../../../base/widgets/bottom_sheet.dart';
import '../bottom_sheet_view_controller.dart';

class MemberPickerViewController extends BottomSheetViewController {
  final ClubMemberService _clubMemberService = Get.find<ClubMemberService>();

  late Rx<String> title = "회원 선택".obs;
  late List<int> initialMemberIds;
  late bool multipleSelect;
  late Function(List<ClubMember>)? onSelected;

  List<ClubMember> clubMembers = [];
  RxList<ClubMember> selectedMembers = RxList();

  @override
  void init(Map<String, dynamic> arguments) {
    title.value = arguments["title"];
    initialMemberIds = arguments["initialMemberIds"];
    onSelected = arguments["onSelected"] as Function(List<ClubMember>)?;
    multipleSelect = arguments["multipleSelect"];
  }

  Future<void> initMembers() async {
    clubMembers = await _clubMemberService.getConfirmedClubMembers();
    selectedMembers =
        clubMembers.where((member) => initialMemberIds.contains(member.id)).toList().obs;
  }

  void toggleSelect(ClubMember member) {
    if (multipleSelect) {
      if (selectedMembers.contains(member)) {
        selectedMembers.remove(member);
      } else {
        selectedMembers.add(member);
      }
    } else {
      selectedMembers.clear();
      selectedMembers.add(member);
    }
  }

  void selectMembers() {
    onSelected?.call(selectedMembers);
    Get.find<BottomSheetController>().popView();
  }
}
