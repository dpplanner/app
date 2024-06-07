import 'package:dplanner/controllers/size.dart';
import 'package:dplanner/models/reservation_model.dart';
import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../services/reservation_api_service.dart';
import '../style.dart';
import 'nextpage_button.dart';
import 'outline_textform.dart';

class ReservationAdminCard extends StatelessWidget {
  final VoidCallback onTap;
  final int type;
  final ReservationModel reservation;

  const ReservationAdminCard(
      {super.key,
      required this.type,
      required this.reservation,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        getRequestInfo(types: type, reservation: reservation);
      },
      child: Container(
        width: SizeController.to.screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColor.backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3, right: 6),
                child: SvgPicture.asset(
                  type == 1
                      ? 'assets/images/notification_icon/icon_request.svg'
                      : type == 2
                          ? 'assets/images/notification_icon/icon_accept.svg'
                          : 'assets/images/notification_icon/icon_reject.svg',
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        reservation.clubMemberName,
                        style: const TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                      const Text(
                        " 님의",
                        style: TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        reservation.resourceName,
                        style: const TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                      Text(
                        type == 1
                            ? " 예약 요청이 있어요"
                            : type == 2
                                ? " 예약 요청을 승인했어요"
                                : " 예약 요청을 거절했어요",
                        style: const TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "신청 일시:  ",
                        style: TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      Text(
                        "${DateFormat("yy.MM.dd  HH:00-", 'ko_KR').format(DateTime.parse(reservation.startDateTime))}${reservation.endDateTime.substring(11, 16)}",
                        style: const TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getRequestInfo(
      {required int types, required ReservationModel reservation}) async {
    bool checkedMore = false;

    Get.bottomSheet(
      isScrollControlled: true,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: SizeController.to.screenHeight * 0.7,
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                        child: SvgPicture.asset(
                          'assets/images/extra/showmodal_scrollcontrolbar.svg',
                        ),
                      ),
                      Text(
                        types == 1
                            ? "예약 요청"
                            : types == 2
                                ? "승인된 예약 정보"
                                : "거절된 예약 정보",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "신청자",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                              Text(
                                reservation.clubMemberName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 32, bottom: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "물품",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                Text(
                                  reservation.resourceName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "신청 시간",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                              Text(
                                "${DateFormat("yy.MM.dd  HH:00-", 'ko_KR').format(DateTime.parse(reservation.startDateTime))}${reservation.endDateTime.substring(11, 16)}",
                                style: const TextStyle(
                                    color: AppColor.textColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 32, bottom: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "요청 시간",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                Text(
                                  DateFormat("yy.MM.dd  HH:mm", 'ko_KR').format(
                                      DateTime.parse(reservation.createDate)),
                                  style: const TextStyle(
                                      color: AppColor.textColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          if (types == 3)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 32),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Flexible(
                                    flex: 1,
                                    child: Text(
                                      "거절 사유",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      reservation.rejectMessage ??
                                          "거절 사유가 없습니다.",
                                      style: const TextStyle(
                                          color: AppColor.textColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                checkedMore = !checkedMore;
                              });
                            },
                            child: Row(
                              children: [
                                const Text(
                                  "내용 더보기",
                                  style: TextStyle(
                                      color: AppColor.textColor2,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                Icon(
                                  checkedMore
                                      ? SFSymbols.chevron_up
                                      : SFSymbols.chevron_down,
                                  color: AppColor.textColor2,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                          if (checkedMore && reservation.title != "")
                            Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "예약 제목",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    reservation.title,
                                    style: const TextStyle(
                                        color: AppColor.textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          if (checkedMore && reservation.usage != "")
                            Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "사용 용도",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    reservation.usage,
                                    style: const TextStyle(
                                        color: AppColor.textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          if (checkedMore && reservation.invitees.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "함께 사용하는 사람",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          String inviteesNames = reservation
                                              .invitees
                                              .map((invitee) =>
                                                  invitee["clubMemberName"]
                                                      as String)
                                              .join(", ");

                                          return AlertDialog(
                                            backgroundColor:
                                                AppColor.backgroundColor,
                                            content: SingleChildScrollView(
                                              child: Text(
                                                inviteesNames,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      reservation.invitees.length >= 2
                                          ? "${reservation.invitees[0]["clubMemberName"]} 외 ${reservation.invitees.length - 1}명"
                                          : reservation.invitees
                                              .map((invitee) =>
                                                  invitee["clubMemberName"]
                                                      as String)
                                              .join(", "),
                                      style: const TextStyle(
                                          color: AppColor.textColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (checkedMore)
                            Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "물품 공유 여부",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    reservation.sharing ? "가능" : "불가능",
                                    style: const TextStyle(
                                        color: AppColor.textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (types == 1)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                    child: Row(
                      children: [
                        Expanded(
                          child: NextPageButton(
                            text: const Text(
                              "거절하기",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.backgroundColor),
                            ),
                            buttonColor: AppColor.subColor3,
                            onPressed: () {
                              rejectReservation();
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: NextPageButton(
                            text: const Text(
                              "승인하기",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.backgroundColor),
                            ),
                            buttonColor: AppColor.objectColor,
                            onPressed: () async {
                              try {
                                await ReservationApiService.patchReservation(
                                    reservationIds: [reservation.reservationId],
                                    rejectMessages: [],
                                    isConfirmed: true);
                              } catch (e) {
                                print(e.toString());
                                snackBar(
                                    title: "예약 승인 실패", content: e.toString());
                              }
                              onTap();
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      backgroundColor: AppColor.backgroundColor,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
    );
  }

  Future<void> rejectReservation() async {
    final formKey1 = GlobalKey<FormState>();
    final TextEditingController rejectMessage = TextEditingController();
    bool isFocused1 = false;

    await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Center(
            child: Text(
              "예약 거절",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "거절 사유를 작성해주세요",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                Flexible(
                  child: Form(
                    key: formKey1,
                    child: OutlineTextForm(
                      hintText: '예시) 적합하지 않은 예약입니다',
                      controller: rejectMessage,
                      isFocused: isFocused1,
                      noLine: false,
                      fontSize: 14,
                      onChanged: (value) {
                        setState(() {
                          isFocused1 = value.isNotEmpty;
                        });
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: NextPageButton(
                  text: const Text(
                    "거절하기",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.backgroundColor),
                  ),
                  buttonColor: AppColor.objectColor,
                  onPressed: () async {
                    try {
                      await ReservationApiService.patchReservation(
                          reservationIds: [reservation.reservationId],
                          rejectMessages: [rejectMessage.text],
                          isConfirmed: false);
                    } catch (e) {
                      print(e.toString());
                      snackBar(title: "예약 거절 실패", content: e.toString());
                    }
                    onTap();
                    Get.back();
                    Get.back();
                  },
                ),
              ),
              TextButton(
                onPressed: Get.back,
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.transparent;
                      }
                      return Colors.transparent;
                    },
                  ),
                ),
                child: const Text(
                  "취소",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textColor2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
