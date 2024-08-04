import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/models/club_member_model.dart';
import 'package:dplanner/pages/post_page.dart';
import 'package:dplanner/const/style.dart';
import 'package:flutter/material.dart';
import 'package:dplanner/services/club_alert_api_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../models/club_alert_message_model.dart';
import '../models/reservation_model.dart';
import '../services/reservation_api_service.dart';

class NotificationCard extends StatefulWidget {
  final int id;
  final AlertMessageType type;
  final String title;
  final String content;
  final bool isRead;
  final String redirectUrl;
  final AlertMessageInfoType infoType;
  final String? info;
  final bool isSelected;

  const NotificationCard({
    super.key,
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.isRead,
    required this.redirectUrl,
    required this.infoType,
    required this.info,
    required this.isSelected
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  late bool isRead = widget.isRead;
  late bool isSelected = widget.isSelected;

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _handleMessage());
      Get.parameters.clear();
      setState(() {
        isSelected = false;
      });
    }

    return GestureDetector(
      onTap: _handleMessage,
      child: Container(
        color: (!isRead)
            ? AppColor.markColor.withOpacity(0.15)
            : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
               padding: const EdgeInsets.only(right: 12.0),
               child: SvgPicture.asset(
                 "assets/images/notification_icon/icon_${widget.type.getLowerCase()}.svg",
                 height: 24,
               ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    Text(
                      widget.content,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMessage() async {
      await ClubAlertApiService.markAsRead(widget.id);

      setState(() {
        isRead = true;
      });

      switch(widget.infoType) {
        case AlertMessageInfoType.MEMBER:
          _handleMemberNotification();

        case AlertMessageInfoType.POST:
          _handlePostNotification();

        case AlertMessageInfoType.RESERVATION:
          await _handleReservationNotification();

        case AlertMessageInfoType.RETURN:
          await _handleReturnNotification();

        default:
          // 데이터가 잘못된 케이스(NOTHING)
          print("[Error] infoType = ${widget.infoType}");
      }
    }

  bool hasAuthority(String authority) {
    ClubMemberModel user = MemberController.to.clubMember();
    return user.role == "ADMIN"
        || (user.clubAuthorityTypes != null && user.clubAuthorityTypes!.contains(authority));
  }

  Future<bool> _isPastReservation(String reservationId) async {
    ReservationModel reservation = await ReservationApiService.getReservation(reservationId: int.parse(reservationId));

    // 지난 예약
    if (DateTime.parse(reservation.startDateTime).isBefore(DateTime.now())) return true;

    return false;
  }

  void _handleMemberNotification() {
    // 클럽 가입 요청
    if (hasAuthority("MEMBER_ALL")) { // 권한 변경 후에도 들어가는거 방지
      String clubMemberId = widget.info!;
      Get.toNamed("/club_member_list", parameters: {"clubMemberId": clubMemberId});
    }
  }

  void _handlePostNotification() {
    // 게시글 삭제 알림을 제외한 모든 알림은 해당 게시글로 이동
    if (widget.info != null) {
      int postId = int.parse(widget.info!);
      Get.to(() => PostPage(postId: postId), arguments: 1);
    }
  }

  Future<void> _handleReservationNotification() async {
    switch(widget.type) {
      case AlertMessageType.REQUEST:
        await _handleReservationRequestNotification();

      case AlertMessageType.ACCEPT:
        await _handleReservationAcceptNotification();

      case AlertMessageType.REJECT:
        _handleReservationRejectNotification();

      case AlertMessageType.INFO:
        await _handleReservationInfoNotification();

      default:
        // 데이터가 잘못된 케이스(REPORT, NOTICE)
        print("[Error] type = ${widget.type}");
    }
  }

  Future<void> _handleReturnNotification() async {
    switch(widget.type) {
      case AlertMessageType.REQUEST:
        await _handleReturnRequestNotification();
      case AlertMessageType.INFO:
        await _handleReturnInfoNotification();
      default:
        // 데이터가 잘못된 케이스(REPORT, NOTICE)
        print("[Error] type = ${widget.type}");
    }
  }

  Future<void> _handleReservationRequestNotification() async {
    if (hasAuthority("SCHEDULE_ALL")) { // 권한 변경 후에도 들어가는거 방지
      // 예약 요청 -> 예약 관리 - 승인된 이후에도 동일하게
      String reservationId = widget.info!;
      _toReservationManagePage(reservationId: reservationId, isReturned: null);
    }
  }

  void _handleReservationRejectNotification() {
    // 관리자에 의한 삭제 -> 아무것도 안함
    // 예약 거절 -> 거절된 예약 > 예약 정보
    if (widget.info != null) {
      _toMyReservationPage(reservationId: widget.info!, isPast: null, isRejected: true);
    }
  }

  Future<void> _handleReservationAcceptNotification() async {
    // 예약 승인
    String reservationId = widget.info!;
    await _toMyReservationPage(reservationId: reservationId, isPast: (await _isPastReservation(reservationId)), isRejected: null);
  }

  Future<void> _handleReservationInfoNotification() async {
    // 예약 리마인드 -> 내 예약 목록
    if (widget.info == null) {
      Get.toNamed("/my_reservation");
    } else {
      // 예약 초대됨, 예약 시작, 예약 종료 -> 내 예약 목록 > 예약 정보
      String reservationId = widget.info!;
      await _toMyReservationPage(reservationId: reservationId, isPast: (await _isPastReservation(reservationId)), isRejected: null);
    }
  }

  Future<void> _handleReturnRequestNotification() async {
    // 반납 메시지 리마인드
    String reservationId = widget.info!;
    _toMyReservationPage(reservationId: reservationId, isPast: true, isRejected: null);
  }

  Future<void> _handleReturnInfoNotification() async {
    if(hasAuthority("RETURN_MSG_READ")) {
      // 반납 메시지 도착 -> 예약 요청 > 승인한 예약
      String reservationId = widget.info!;
      _toReservationManagePage(reservationId: reservationId, isReturned: true);
    }
  }

  Future<void> _toReservationManagePage({required String reservationId, required bool? isReturned}) async {
    ReservationModel reservation = await ReservationApiService.getReservation(reservationId: int.parse(reservationId));

    Map<String, String>? params = {};
    params.putIfAbsent("reservationId", () => reservationId);
    params.putIfAbsent("status", () => reservation.status);
    if (isReturned != null) params.putIfAbsent("isReturned", () => isReturned.toString());

    Get.toNamed("/reservation_list", parameters: params);
  }

  Future<void> _toMyReservationPage({
    required String? reservationId,
    required bool? isPast,
    required bool? isRejected}) async {

    Map<String, String>? params = {};
    if (reservationId != null) params.putIfAbsent("reservationId", () => reservationId);
    if (isPast != null) params.putIfAbsent("isPast", () => isPast.toString());
    if (isRejected != null) params.putIfAbsent("isRejected", () => isRejected.toString());

    Get.toNamed("/my_reservation", parameters: params);
  }
}
