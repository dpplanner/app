import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../config/constants/app_colors.dart';
import '../../../../../data/model/club/club_member.dart';
import '../../../../../data/model/reservation/reservation.dart';
import '../../../../../data/model/reservation/reservation_invitee.dart';
import '../../../../../service/reservation_service.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_navigator.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_view_controller.dart';
import '../member_picker/member_picker_view.dart';

class ReservationModifyViewController extends BottomSheetViewController {
  final BottomSheetNavigator _navigator = Get.find<BottomSheetNavigator>();
  final ReservationService _reservationService = Get.find<ReservationService>();

  late Rx<Reservation> reservation = Rx<Reservation>(Reservation.ofDummy());
  late bool isManager = false;

  TextEditingController reservationTitleForm = TextEditingController();
  TextEditingController reservationUsageForm = TextEditingController();

  @override
  void reset() {
    reservationTitleForm.clear();
    reservationUsageForm.clear();
  }

  @override
  void init(Map<String, dynamic> arguments) {
    reservation = Rx<Reservation>(arguments["reservation"]);
    isManager = arguments["isManager"];
  }

  get resourceName => reservation.value.resourceName;

  get reservationOwnerName => reservation.value.clubMemberName;

  get reservationDate =>
      DateFormat("yyyy. MM. dd. E요일", 'ko_KR').format(reservation.value.startDateTime);

  get reservationTime {
    final startHour = reservation.value.startDateTime.hour;
    final endHour =
        reservation.value.endDateTime.hour == 0 ? 24 : reservation.value.endDateTime.hour;
    return "$startHour:00 ~ $endHour:00 (${endHour - startHour}시간)";
  }

  get reservationColor => ReservationColors.fromHexCode(reservation.value.color);

  List<ReservationInvitee> get reservationInvitees => reservation.value.invitees;

  get reservationSharing => reservation.value.sharing;

  @override
  void onInit() {
    super.onInit();
    reservationTitleForm.text = reservation.value.title;
    reservationUsageForm.text = reservation.value.usage;
  }

  Future<void> modifyReservation() async {
    try {
      reservation.value.title = reservationTitleForm.text;
      reservation.value.usage = reservationUsageForm.text;

      await _reservationService.updateReservation(reservation: reservation.value);
      if (isManager) {
        await _reservationService.updateReservationOwner(reservation: reservation.value);
      }
      _navigator.close(success: true);
    } catch (e) {
      _navigator.close(success: false);
      snackBar(title: "예약을 수정하지 못했습니다.", content: "잠시 후 다시 시도해 주세요");
    }
  }

  Future<void> changeReservationOwner() async {
    _navigator.pushView(view: MemberPickerView(), arguments: {
      "title": "예약자",
      "initialMemberIds": [reservation.value.clubMemberId],
      "multipleSelect": false,
      "onSelected": (List<ClubMember> selectedMembers) {
        reservation.update((res) {
          if (res != null) {
            res.clubMemberId = selectedMembers[0].id;
            res.clubMemberName = selectedMembers[0].name;
          }
        });
      }
    });
  }

  void changeReservationColor(Color value) {
    reservation.value.color = ReservationColors.getColorHex(value);
  }

  Future<void> changeReservationInvitees() async {
    _navigator.pushView(view: MemberPickerView(), arguments: {
      "title": "함께 사용하는 사람",
      "initialMemberIds": reservation.value.invitees.map((invitee) => invitee.id).toList(),
      "multipleSelect": true,
      "onSelected": (List<ClubMember> selectedMembers) {
        reservation.update((res) {
          if (res != null) {
            res.invitees = selectedMembers
                .map((member) => ReservationInvitee(
                    id: member.id,
                    name: member.name,
                    profileImageUrl: member.url,
                    isDeleted: false))
                .toList();
          }
        });
      }
    });
  }

  void changeReservationSharing(bool? value) {
    reservation.update((res) {
      if (res != null) res.sharing = (value == true);
    });
  }
}
