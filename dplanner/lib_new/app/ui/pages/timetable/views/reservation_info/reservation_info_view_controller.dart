import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../config/constants/app_colors.dart';
import '../../../../../data/model/club/club_authority_type.dart';
import '../../../../../data/model/club/club_member.dart';
import '../../../../../data/model/reservation/reservation.dart';
import '../../../../../data/model/reservation/reservation_status_type.dart';
import '../../../../../service/reservation_service.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_navigator.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_view_controller.dart';
import '../../../../base/widgets/dialog.dart';
import '../../../../base/widgets/snackbar.dart';
import '../reservation_modify/reservation_modify_view.dart';
import '../reservation_return/reservation_return_view.dart';
import 'dialogs/cancel_dialog_view.dart';
import 'dialogs/delete_dialog_view.dart';
import 'dialogs/reject_dialog_view.dart';

class ReservationInfoViewController extends BottomSheetViewController {
  final BottomSheetNavigator _navigator = Get.find<BottomSheetNavigator>();
  final ReservationService _reservationService = Get.find<ReservationService>();

  late Reservation reservation;
  late bool isManager;
  late ClubMember me;

  @override
  void init(Map<String, dynamic> arguments) {
    reservation = arguments["reservation"];
    isManager = arguments["isManager"];
    me = arguments["me"];
  }

  String get title {
    if (isManager) {
      if (reservation.isRequest() && !reservation.isOwner(me.id)) {
        return "예약 요청";
      }
    } else {
      if (reservation.isRequest()) {
        return "승인 대기중";
      }
    }
    return "예약 정보";
  }

  String get reservationStatus {
    switch (reservation.status) {
      case ReservationStatusType.REQUEST:
        return "승인 대기중";
      case ReservationStatusType.CONFIRMED:
        {
          if (!reservation.returned) {
            return "승인 완료";
          } else {
            return "승인 및 반납 완료";
          }
        }
      case ReservationStatusType.REJECTED:
        return "거절됨";
    }
  }

  String get reservationOwnerName => reservation.clubMemberName;

  String get reservationDate =>
      DateFormat("yyyy. MM. dd. E요일", 'ko_KR').format(reservation.startDateTime);

  String get reservationTime {
    final startHour = reservation.startDateTime.hour;
    final endHour = reservation.endDateTime.hour == 0 ? 24 : reservation.endDateTime.hour;
    return "$startHour:00 ~ $endHour:00 (${endHour - startHour}시간)";
  }

  Color get reservationColor => ReservationColors.fromHexCode(reservation.color);

  String get reservationTitle => reservation.title;

  String get shareInfo => reservation.sharing ? "가능" : "불가능";

  bool hasAdditionalInfo() =>
      reservation.hasTitle() || reservation.hasUsage() || reservation.hasInvitees();

  String get reservationUsage => reservation.usage;

  String get reservationInvitees {
    if (reservation.invitees.length >= 2) {
      return "${reservation.invitees[0].name} 외 ${reservation.invitees.length - 1}명";
    } else {
      return reservation.invitees[0].name;
    }
  }

  bool hasReturnInfo() =>
      reservation.returned && (reservation.hasReturnMessage() || reservation.hasReturnImages());

  bool hasAuthority() => me.hasAuthority(ClubAuthorityType.RETURN_MSG_READ);

  String get returnMessage => reservation.returnMessage!;

  List<String> get returnImageUrls => reservation.attachmentsUrl;

  bool requireReturn() =>
      reservation.isOwner(me.id) &&
      !reservation.returned &&
      reservation.isConfirmed() &&
      reservation.isStarted();

  bool isHalfButtonRowVisible() {
    if (isManager) return true; // 매니저 -> [삭제 / 수정] or [거절 / 승인] 항상 노출
    if (!reservation.isOwner(me.id)) return false; // 일반 회원 & 남의 예약 -> 항상 버튼 없음
    return !reservation.isStarted(); // 일반 회원 & 내 예약 -> 예약 시작 전까지 [취소 / 수정] 노출
  }

  // 매니저 & 요청 -> [거절 / 승인]
  bool isConfirmable() => isManager && reservation.isRequest() && !reservation.isOwner(me.id);

  // 매니저 & 요청 아님-> [삭제 / 수정]
  bool isDeletable() => isManager;

  // 일반 회원 & 시작 전 -> [취소 / 수정]
  bool isCancelable() => !isManager && !reservation.isStarted();

  Future<void> confirmReservation() async {
    try {
      await _reservationService.confirmReservation(reservations: [reservation]);
      _navigator.close(success: true);
    } catch (e) {
      _navigator.close(success: false);
      snackBar(title: "예약을 승인하지 못했습니다.", content: "잠시 후 다시 시도해 주세요");
    }
  }

  Future<void> rejectReservation() async {
    try {
      var doReject =
          await dialog(view: RejectDialogView(), arguments: {"reservation": reservation});
      if (doReject == true) {
        await _reservationService.rejectReservation(reservations: [reservation]);
        _navigator.close(success: true);
      }
    } catch (e) {
      _navigator.close(success: false);
      snackBar(title: "예약을 거절하지 못했습니다.", content: "잠시 후 다시 시도해 주세요");
    }
  }

  Future<void> deleteReservation() async {
    try {
      var doDelete = await dialog(view: DeleteDialogView());
      if (doDelete == true) {
        await _reservationService.deleteReservation(reservation: reservation);
        _navigator.close(success: true);
      }
    } catch (e) {
      _navigator.close(success: false);
      snackBar(title: "예약을 삭제하지 못했습니다.", content: "잠시 후 다시 시도해 주세요");
    }
  }

  Future<void> cancelReservation() async {
    try {
      var doCancel = await dialog(view: CancelDialogView());
      if (doCancel == true) {
        await _reservationService.cancelReservation(reservation: reservation);
        _navigator.close(success: true);
      }
    } catch (e) {
      _navigator.close(success: false);
      snackBar(title: "예약을 취소하지 못했습니다.", content: "잠시 후 다시 시도해 주세요");
    }
  }

  Future<void> modifyReservation() async {
    _navigator.pushView(
        view: ReservationModifyView(),
        arguments: {"reservation": reservation.copy(), "isManager": isManager});
  }

  Future<void> toReturnReservationView() async {
    _navigator.pushView(view: ReservationReturnView(), arguments: {"reservation": reservation});
  }
}
