import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../config/constants/app_colors.dart';
import '../../../../../data/model/club/club_member.dart';
import '../../../../../data/model/reservation/reservation_invitee.dart';
import '../../../../../data/model/resource/resource.dart';
import '../../../../../service/reservation_service.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_navigator.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_view_controller.dart';
import '../../../../base/widgets/snackbar.dart';
import '../member_picker/member_picker_view.dart';
import '../reservation_time_picker/reservation_time_picker_view.dart';

class ReservationCreateViewController extends BottomSheetViewController {
  final BottomSheetNavigator _navigator = Get.find<BottomSheetNavigator>();
  final ReservationService _reservationService = Get.find<ReservationService>();

  late Resource resource;
  late bool isManager;
  late ClubMember me;

  Rxn<ClubMember> reservationOwner = Rxn<ClubMember>();
  Rx<DateTime> reservationStartDateTime = DateTime.now().obs;
  Rx<DateTime> reservationEndDateTime = DateTime.now().obs;
  Rx<Color> reservationColor = ReservationColors.reservationColors.first.obs;
  TextEditingController reservationTitleForm = TextEditingController();
  TextEditingController reservationUsageForm = TextEditingController();
  RxList<ReservationInvitee> reservationInvitees = RxList();
  RxBool reservationSharing = true.obs;

  @override
  void reset() {
    reservationOwner = Rxn<ClubMember>();
    reservationStartDateTime = DateTime.now().obs;
    reservationEndDateTime = DateTime.now().obs;
    reservationColor = ReservationColors.reservationColors.first.obs;
    reservationTitleForm.clear();
    reservationUsageForm.clear();
    reservationInvitees.clear();
    reservationSharing = true.obs;
  }

  @override
  void init(Map<String, dynamic> arguments) {
    resource = arguments["resource"];
    isManager = arguments["isManager"];
    me = arguments["me"];

    reservationOwner.value = me;
  }

  get resourceName => resource.name;

  String get reservationOwnerName => reservationOwner.value?.name ?? "";

  String get reservationDate =>
      DateFormat("yyyy. MM. dd. E요일", 'ko_KR').format(reservationStartDateTime.value);

  bool get isTimeSelected =>
      reservationStartDateTime.value.hour != reservationEndDateTime.value.hour;

  String get reservationTime {
    final startHour = reservationStartDateTime.value.hour;
    final endHour = reservationEndDateTime.value.hour == 0 ? 24 : reservationEndDateTime.value.hour;
    return "$startHour:00 ~ $endHour:00 (${endHour - startHour}시간)";
  }

  Future<void> changeReservationOwner() async {
    _navigator.pushView(view: MemberPickerView(), arguments: {
      "title": "예약자",
      "initialMemberIds": [reservationOwner.value!.id],
      "multipleSelect": false,
      "onSelected": (List<ClubMember> selectedMembers) {
        reservationOwner.value = selectedMembers[0];
      }
    });
  }

  void changeReservationTime() {
    _navigator.pushView(view: ReservationTimePickerView(), arguments: {
      "resource": resource,
      "isManager": isManager,
      "onSelected": (startDateTime, endDateTime) {
        reservationStartDateTime.value = startDateTime;
        reservationEndDateTime.value = endDateTime;
      },
      if (isTimeSelected)
        "initialTime": {
          "start": reservationStartDateTime.value,
          "end": reservationEndDateTime.value
        },
    });
  }

  void changeReservationColor(Color value) {
    reservationColor.value = value;
  }

  Future<void> changeReservationInvitees() async {
    _navigator.pushView(view: MemberPickerView(), arguments: {
      "title": "함께 사용하는 사람",
      "initialMemberIds": reservationInvitees.map((invitee) => invitee.id).toList(),
      "multipleSelect": true,
      "onSelected": (List<ClubMember> selectedMembers) {
        reservationInvitees.value = selectedMembers
            .map((member) =>
            ReservationInvitee(
                id: member.id, name: member.name, profileImageUrl: member.url, isDeleted: false))
            .toList();
      }
    });
  }

  void changeReservationSharing(bool? value) {
    reservationSharing.value = (value == true);
  }

  Future<void> createReservation() async {
    try {
      await _reservationService.createReservation(
          reservationOwnerId: reservationOwner.value!.id,
          resourceId: resource.id,
          startDateTime: reservationStartDateTime.value,
          endDateTime: reservationEndDateTime.value,
          color: ReservationColors.getColorHex(reservationColor.value));
      _navigator.close(success: true);
    } catch (e) {
      _navigator.close(success: false);
      snackBar(title: "예약을 신청하지 못했습니다.", content: "잠시 후 다시 시도해 주세요");
    }
  }
}