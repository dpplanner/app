import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dplanner/controllers/size.dart';
import 'package:dplanner/models/club_member_model.dart';
import 'package:dplanner/widgets/snack_bar.dart';
import 'package:dplanner/widgets/underline_textform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../controllers/club.dart';
import '../controllers/member.dart';
import '../models/reservation_model.dart';
import '../pages/error_page.dart';
import '../services/club_member_api_service.dart';
import '../services/reservation_api_service.dart';
import '../const/style.dart';
import 'color_scroll_widget.dart';
import 'color_unit_widget.dart';
import 'full_screen_image.dart';
import 'nextpage_button.dart';
import 'outline_textform.dart';

enum Open { yes, no }

class ReservationBigCard extends StatelessWidget {
  final VoidCallback onTap;
  final ReservationModel reservation;
  final bool isRecent;
  final String endTime;

  const ReservationBigCard({
    super.key,
    required this.onTap,
    required this.reservation,
    required this.endTime,
    this.isRecent = false,
  });

  bool isFromNotification() {
    Map<String, String?> params = Get.parameters;
    return params.containsKey("reservationId") &&
        params["reservationId"] != null &&
        int.parse(params["reservationId"]!) == reservation.reservationId;
  }

  @override
  Widget build(BuildContext context) {
    if (isFromNotification()) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
          getReservationInfo(reservation: reservation, types: 0));
      Get.parameters.clear();
    }

    return reservation.isDummy
        ? Container(
            width: SizeController.to.screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColor.subColor4
            ),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(""),
                  Text(
                    "예약이 없어요",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  Text(""),
                ]
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              getReservationInfo(reservation: reservation, types: 0);
            },
            child: Container(
              width: SizeController.to.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isRecent ? AppColor.subColor2 : AppColor.backgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${DateFormat("yyyy년 MM월 dd일 H:00 ~", 'ko_KR').format(DateTime.parse(reservation.startDateTime))} $endTime:00",
                      style: const TextStyle(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                    Text(
                      reservation.resourceName,
                      style: const TextStyle(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    Row(
                      children: [
                        Text(
                          reservation.clubMemberId ==
                                  MemberController.to.clubMember().id
                              ? "내 예약"
                              : "${reservation.clubMemberName}의 예약",
                          style: const TextStyle(
                              color: AppColor.textColor2,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                        if (reservation.status == "REQUEST")
                          const Text(
                            " - 승인 대기중",
                            style: TextStyle(
                                color: AppColor.textColor2,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                        if (reservation.status == "REJECTED")
                          const Text(
                            " - 거절됨",
                            style: TextStyle(
                                color: AppColor.textColor2,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                        if (reservation.returned)
                          const Text(
                            " - 반납 완료",
                            style: TextStyle(
                                color: AppColor.textColor2,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  /// types == 0 : 예약 정보
  /// types == 1 : 예약 수정
  /// types == 2 : 멤버 선택
  /// types == 3 : 반납 하기
  Future<void> getReservationInfo(
      {required ReservationModel reservation, required int types}) async {
    final formKey1 = GlobalKey<FormState>();
    final TextEditingController title = TextEditingController();
    bool isFocused1 = false;

    final formKey2 = GlobalKey<FormState>();
    final TextEditingController usage = TextEditingController();
    bool isFocused2 = false;

    final formKey3 = GlobalKey<FormState>();
    final TextEditingController message = TextEditingController();
    bool isFocused3 = false;

    bool checkedMore = false;
    bool checkedReturn = false;
    int startTime = int.parse(reservation.startDateTime.substring(11, 13));
    title.text = reservation.title;
    usage.text = reservation.usage;
    List<Map<String, dynamic>> invitees = reservation.invitees;
    List<Map<String, dynamic>> updateInvitees = [];
    List<int> lastPages = [];
    List<bool> isChecked = [];
    Open open = reservation.sharing ? Open.yes : Open.no;

    List<XFile> selectedImages = [];
    int maxImageCount = 5;

    Color selectedColor = AppColor.ofHex(reservation.color);

    Future<void> pickImage(StateSetter setState) async {
      try {
        XFile? image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() {
            selectedImages.add(image);
          });
        }
      } catch (e) {
        print('Error while picking an image: $e');
      }
    }

    Future<List<ClubMemberModel>> getMemberList(StateSetter setState) async {
      try {
        List<ClubMemberModel> members =
            await ClubMemberApiService.getClubMemberList(
                clubId: ClubController.to.club().id, confirmed: true);
        List<ClubMemberModel> removeMeMembers = members
            .where((member) => member.id != MemberController.to.clubMember().id)
            .toList();

        return removeMeMembers;
      } catch (e) {
        print(e.toString());
      }
      return [];
    }

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
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              types == 0
                                  ? "예약 정보"
                                  : types == 1
                                      ? "예약 수정"
                                      : types == 2
                                          ? "함께 사용하는 사람"
                                          : "반납하기",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (lastPages.isNotEmpty && lastPages.last != -1)
                            Positioned(
                              left: 14,
                              top: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    types = lastPages.removeLast();
                                  });
                                },
                                child: const Icon(SFSymbols.chevron_left),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Visibility(
                        visible: !(types == 0 || types == 1),
                        replacement: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (types == 0)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "예약자",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      reservation.clubMemberName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            if (types == 0)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "예약 상태",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      reservation.status == "REQUEST"
                                          ? "승인 대기중"
                                          : reservation.status == "CONFIRMED" &&
                                                  !reservation.returned
                                              ? "승인 완료"
                                              : reservation.status ==
                                                          "CONFIRMED" &&
                                                      reservation.returned
                                                  ? "승인 및 반납 완료"
                                                  : "거절됨",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 32),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "예약 품목",
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
                                  "예약 날짜",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                Text(
                                  DateFormat("yyyy. MM. dd. E요일", 'ko_KR')
                                      .format(DateTime.parse(
                                          reservation.startDateTime)),
                                  style: const TextStyle(
                                      color: AppColor.textColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 32, bottom: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "예약 시간",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "$startTime:00 ~ $endTime:00 (${int.parse(endTime) - startTime}시간)",
                                    style: const TextStyle(
                                        color: AppColor.textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 32.0),
                                child : Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "예약 색상",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                      types == 0
                                          ? ColorUnitWidget(
                                          color: selectedColor,
                                          showBorder: true,
                                          borderWidth: 5.0)
                                          : ColorScrollWidget(
                                          defaultColor: selectedColor,
                                          availableColors: AppColor.reservationColors,
                                          onColorChanged: (color) {
                                            setState(() {
                                              selectedColor = color;
                                            });
                                          })
                                    ]
                                )
                            ),
                            if (reservation.status == "REJECTED")
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 16, bottom: 16),
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
                                            color: AppColor.markColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Visibility(
                              visible: types == 0,
                              replacement: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "예약 제목(선택)",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 12.0),
                                          child: Form(
                                              key: formKey1,
                                              child: UnderlineTextForm(
                                                hintText: '예약 제목을 입력해주세요',
                                                controller: title,
                                                isFocused: isFocused1,
                                                noLine: true,
                                                isRight: true,
                                                noErrorSign: true,
                                                isWritten: false,
                                                fontSize: 15,
                                                onChanged: (value) {
                                                  setState(() {
                                                    isFocused1 =
                                                        value.isNotEmpty;
                                                  });
                                                },
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "사용 용도(선택)",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 12.0),
                                          child: Form(
                                              key: formKey2,
                                              child: UnderlineTextForm(
                                                hintText: '사용 용도를 입력해주세요',
                                                controller: usage,
                                                isFocused: isFocused2,
                                                noLine: true,
                                                isRight: true,
                                                noErrorSign: true,
                                                isWritten: false,
                                                fontSize: 15,
                                                onChanged: (value) {
                                                  setState(() {
                                                    isFocused2 =
                                                        value.isNotEmpty;
                                                  });
                                                },
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, bottom: 32.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "함께 사용하는 사람(선택)",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              updateInvitees.clear();
                                              isChecked.clear();
                                              updateInvitees.addAll(invitees);
                                              lastPages.add(types);
                                              types = 2;
                                            });
                                          },
                                          child: Text(
                                            (types == 0 || types == 1) &&
                                                    invitees.isEmpty
                                                ? "선택하기"
                                                : invitees.isNotEmpty &&
                                                        invitees.length >= 2
                                                    ? "${invitees[0]["clubMemberName"]} 외 ${invitees.length - 1}명"
                                                    : invitees
                                                        .map((invitee) => invitee[
                                                                "clubMemberName"]
                                                            as String)
                                                        .join(", "),
                                            style: TextStyle(
                                                color: invitees.isNotEmpty
                                                    ? AppColor.textColor
                                                    : AppColor.textColor2,
                                                fontWeight: invitees.isNotEmpty
                                                    ? FontWeight.w500
                                                    : FontWeight.w400,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Text(
                                    "신청하신 시간에\n다른 사람이 함께 사용할 수 있나요?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    height:
                                        SizeController.to.screenHeight * 0.05,
                                    child: RadioListTile(
                                      title: const Text(
                                        "누구나 함께 사용 가능합니다",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      value: Open.yes,
                                      groupValue: open,
                                      onChanged: (Open? value) {
                                        if (types == 3) {
                                          null;
                                        } else {
                                          setState(() {
                                            open = value!;
                                          });
                                        }
                                      },
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: -10.0),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        SizeController.to.screenHeight * 0.05,
                                    child: RadioListTile(
                                      title: const Text(
                                        "허가받은 사람 외에는 불가능합니다",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      value: Open.no,
                                      groupValue: open,
                                      onChanged: (Open? value) {
                                        if (types == 3) {
                                          null;
                                        } else {
                                          setState(() {
                                            open = value!;
                                          });
                                        }
                                      },
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: -30.0),
                                    ),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: GestureDetector(
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
                                  if (checkedMore &&
                                      reservation.invitees.isNotEmpty)
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
                                                      .map((invitee) => invitee[
                                                              "clubMemberName"]
                                                          as String)
                                                      .join(", ");

                                                  return AlertDialog(
                                                    backgroundColor: AppColor
                                                        .backgroundColor,
                                                    content:
                                                        SingleChildScrollView(
                                                      child: Text(
                                                        inviteesNames,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                                      .map((invitee) => invitee[
                                                              "clubMemberName"]
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
                                  if (reservation.returned &&
                                      MemberController.to.clubMember().role ==
                                          "ADMIN")
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 32.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                checkedReturn = !checkedReturn;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                const Text(
                                                  "반납 정보 보기",
                                                  style: TextStyle(
                                                      color:
                                                          AppColor.textColor2,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16),
                                                ),
                                                Icon(
                                                  checkedReturn
                                                      ? SFSymbols.chevron_up
                                                      : SFSymbols.chevron_down,
                                                  color: AppColor.textColor2,
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (checkedReturn &&
                                            reservation
                                                .attachmentsUrl.isNotEmpty)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    top: 32, bottom: 16),
                                                child: Text(
                                                  "반납 사진",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 120,
                                                child: ListView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children: reservation
                                                      .attachmentsUrl
                                                      .map((imageUrl) {
                                                    String formattedUrl =
                                                        imageUrl.startsWith(
                                                                'https://')
                                                            ? imageUrl
                                                            : 'https://$imageUrl';
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Get.to(() =>
                                                              FullScreenImage(
                                                                  imageUrl:
                                                                      formattedUrl));
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            AspectRatio(
                                                              aspectRatio:
                                                                  1 / 1,
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child: CachedNetworkImage(
                                                                      placeholder: (context, url) => Container(),
                                                                      imageUrl: formattedUrl,
                                                                      errorWidget: (context, url, error) => SvgPicture.asset(
                                                                            'assets/images/base_image/base_post_image.svg',
                                                                          ),
                                                                      fit: BoxFit.cover)),
                                                            ),
                                                            Positioned.fill(
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  gradient:
                                                                      LinearGradient(
                                                                    begin: Alignment
                                                                        .bottomCenter,
                                                                    end: const Alignment(
                                                                        0.0,
                                                                        0.6),
                                                                    colors: [
                                                                      AppColor
                                                                          .objectColor,
                                                                      AppColor
                                                                          .objectColor
                                                                          .withOpacity(
                                                                              0.9),
                                                                      AppColor
                                                                          .objectColor
                                                                          .withOpacity(
                                                                              0.7),
                                                                      AppColor
                                                                          .objectColor
                                                                          .withOpacity(
                                                                              0.5),
                                                                      AppColor
                                                                          .objectColor
                                                                          .withOpacity(
                                                                              0.3),
                                                                      AppColor
                                                                          .objectColor
                                                                          .withOpacity(
                                                                              0.1),
                                                                      Colors
                                                                          .transparent,
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const Positioned(
                                                              bottom: 3,
                                                              right: 7,
                                                              child: Text(
                                                                "자세히 보기",
                                                                style: TextStyle(
                                                                    color: AppColor
                                                                        .backgroundColor2,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        if (checkedReturn &&
                                            reservation.returnMessage != null &&
                                            reservation.returnMessage != "")
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    top: 32, bottom: 16),
                                                child: Text(
                                                  "반납 메시지",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              Text(
                                                reservation.returnMessage ?? "",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        child: Visibility(
                          visible: types != 2,
                          replacement: FutureBuilder(
                              future: getMemberList(setState),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<ClubMemberModel>>
                                      snapshot) {
                                if (snapshot.hasData == false) {
                                  return const SizedBox();
                                } else if (snapshot.hasError) {
                                  return const ErrorPage();
                                } else if (snapshot.data!.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      "선택할 멤버가 없습니다",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.textColor),
                                    ),
                                  );
                                } else {
                                  return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Column(
                                        children: List.generate(
                                            snapshot.data!.length, (index) {
                                          if (updateInvitees.any((element) =>
                                              element["clubMemberId"] ==
                                                  snapshot.data![index].id &&
                                              element["clubMemberName"] ==
                                                  snapshot.data![index].name)) {
                                            isChecked.add(true);
                                          } else {
                                            isChecked.add(false);
                                          }
                                          return Container(
                                            width:
                                                SizeController.to.screenWidth,
                                            color: AppColor.backgroundColor,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            12.0),
                                                                    child:
                                                                        ClipOval(
                                                                      child: snapshot.data![index].url !=
                                                                              null
                                                                          ? CachedNetworkImage(
                                                                              placeholder: (context, url) => Container(),
                                                                              imageUrl: "http://${snapshot.data![index].url!}",
                                                                              errorWidget: (context, url, error) => SvgPicture.asset(
                                                                                    'assets/images/base_image/base_member_image.svg',
                                                                                  ),
                                                                              height: SizeController.to.screenWidth * 0.1,
                                                                              width: SizeController.to.screenWidth * 0.1,
                                                                              fit: BoxFit.fill)
                                                                          : SvgPicture.asset(
                                                                              'assets/images/base_image/base_member_image.svg',
                                                                              height: SizeController.to.screenWidth * 0.1,
                                                                              width: SizeController.to.screenWidth * 0.1,
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            12.0),
                                                                child: Text(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .name,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: AppColor
                                                                        .textColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              ),
                                                              if (!(snapshot
                                                                          .data![
                                                                              index]
                                                                          .role ==
                                                                      "USER" &&
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .isConfirmed))
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          6,
                                                                          2,
                                                                          6,
                                                                          2),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15),
                                                                    color: AppColor
                                                                        .subColor1, // 배경색 설정
                                                                  ),
                                                                  child: Text(
                                                                    (snapshot.data![index].role ==
                                                                            "MANAGER")
                                                                        ? snapshot.data![index].clubAuthorityName ??
                                                                            ""
                                                                        : "관리자",
                                                                    style:
                                                                        const TextStyle(
                                                                      color: AppColor
                                                                          .backgroundColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          11,
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Checkbox(
                                                        value: isChecked[index],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            isChecked[index] =
                                                                value!;
                                                            if (value == true) {
                                                              updateInvitees
                                                                  .add({
                                                                "clubMemberId":
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .id,
                                                                "clubMemberName":
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .name
                                                              });
                                                            } else {
                                                              updateInvitees.removeWhere((element) =>
                                                                  element["clubMemberId"] ==
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .id &&
                                                                  element["clubMemberName"] ==
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .name);
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      ));
                                }
                              }),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "예약 품목",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    reservation.resourceName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 32, bottom: 16),
                                child: Text(
                                  "물품 사진",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Stack(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (selectedImages.length <
                                                maxImageCount) {
                                              pickImage(setState);
                                            }
                                          },
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: SvgPicture.asset(
                                            'assets/images/base_image/base_camera_image.svg',
                                          ),
                                        ),
                                        Positioned(
                                          right: 5,
                                          bottom: 5,
                                          child: Text(
                                            '${selectedImages.length}/$maxImageCount',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: AppColor.textColor2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 100,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children:
                                            selectedImages.map<Widget>((image) {
                                          return Stack(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: AspectRatio(
                                                  aspectRatio: 1 / 1,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.file(
                                                      File(image.path),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: -5,
                                                right: -5,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    selectedImages
                                                        .remove(image);
                                                    setState(() {});
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          AppColor.subColor1,
                                                      shape:
                                                          const CircleBorder(),
                                                      minimumSize:
                                                          const Size(20, 20)),
                                                  child: const Icon(
                                                    SFSymbols.trash,
                                                    color: AppColor
                                                        .backgroundColor,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 32, bottom: 16),
                                child: Text(
                                  "반납 메시지 (선택)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                              ),
                              Form(
                                  key: formKey3,
                                  child: OutlineTextForm(
                                    hintText: '추가 설명이 필요할 경우 작성해주세요',
                                    controller: message,
                                    isFocused: isFocused3,
                                    fontSize: 16,
                                    maxLines: 7,
                                    onChanged: (value) {
                                      setState(() {
                                        isFocused3 = value.isNotEmpty;
                                      });
                                    },
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (reservation.status != "REJECTED")
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                    child: Visibility(
                      visible: types == 0 || types == 1,
                      replacement: Visibility(
                        visible: types == 3,
                        replacement: NextPageButton(
                          text: const Text(
                            "선택 완료",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColor.backgroundColor),
                          ),
                          buttonColor: AppColor.objectColor,
                          onPressed: () {
                            setState(() {
                              invitees.clear();
                              invitees.addAll(updateInvitees);
                              updateInvitees.clear();
                              types = lastPages.removeLast();
                            });
                          },
                        ),
                        child: NextPageButton(
                          text: const Text(
                            "반납 완료",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColor.backgroundColor),
                          ),
                          buttonColor: AppColor.objectColor,
                          onPressed: () async {
                            try {
                              ReservationModel temp =
                                  await ReservationApiService.postReturn(
                                      reservationId: reservation.reservationId,
                                      returnImage: selectedImages,
                                      returnMessage: message.text);
                              onTap();
                              Get.back();
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                        ),
                      ),
                      child: Visibility(
                        visible: (reservation.clubMemberId ==
                                MemberController.to.clubMember().id &&
                            DateTime.now().isBefore(
                                DateTime.parse(reservation.endDateTime))),
                        replacement: Visibility(
                          visible: !reservation.returned &&
                              DateTime.now().isAfter(
                                  DateTime.parse(reservation.endDateTime)) &&
                              reservation.clubMemberId ==
                                  MemberController.to.clubMember().id,
                          child: NextPageButton(
                            text: const Text(
                              "반납하기",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.backgroundColor),
                            ),
                            buttonColor: AppColor.objectColor,
                            onPressed: () {
                              setState(() {
                                types = 3;
                              });
                            },
                          ),
                        ),
                        child: Row(
                          children: [
                            if (types == 0)
                              Expanded(
                                child: NextPageButton(
                                  text: const Text(
                                    "예약 취소하기",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.backgroundColor),
                                  ),
                                  buttonColor: AppColor.subColor3,
                                  onPressed: () async {
                                    try {
                                      await checkCancleReservation(
                                          id: reservation.reservationId,
                                          onTap: onTap);
                                    } catch (e) {
                                      print(e.toString());
                                      snackBar(title: "예약을 취소하지 못했습니다", content: "잠시 후 다시 시도해 주세요");
                                    }
                                  },
                                ),
                              ),
                            if (types == 0)
                              const SizedBox(
                                width: 10,
                              ),
                            Expanded(
                              child: NextPageButton(
                                text: const Text(
                                  "예약 수정하기",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.backgroundColor),
                                ),
                                buttonColor: AppColor.objectColor,
                                onPressed: () async {
                                  if (types == 0) {
                                    setState(() {
                                      types = 1;
                                    });
                                  } else {
                                    List<int> clubMemberIds = invitees
                                        .map((invitee) =>
                                            invitee["clubMemberId"] as int)
                                        .toList();
                                    try {
                                      await ReservationApiService
                                          .putReservation(
                                              reservationId:
                                                  reservation.reservationId,
                                              resourceId:
                                                  reservation.resourceId,
                                              title: title.text,
                                              color: AppColor.getColorHex(selectedColor),
                                              usage: usage.text,
                                              sharing: (open == Open.yes)
                                                  ? true
                                                  : false,
                                              startDateTime:
                                                  reservation.startDateTime,
                                              endDateTime:
                                                  reservation.endDateTime,
                                              reservationInvitees:
                                                  clubMemberIds);
                                      onTap();
                                      Get.back();
                                    } catch (e) {
                                      print(e.toString());
                                      snackBar(title: "예약을 수정하지 못했습니다", content: "잠시 후 다시 시도해 주세요");
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Future<void> checkCancleReservation(
      {required int id, required VoidCallback onTap}) async {
    await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Center(
            child: Text(
              "예약 취소",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "한번 취소한 예약은",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Text(
              "되돌릴 수 없습니다",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                "정말 취소할까요?",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        actions: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: NextPageButton(
                  text: const Text(
                    "취소하기",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.backgroundColor),
                  ),
                  buttonColor: AppColor.objectColor,
                  onPressed: () async {
                    try {
                      await ReservationApiService.cancelReservation(
                          reservationId: id);
                      onTap();
                      Get.back();
                      Get.back();
                    } catch (e) {
                      print(e.toString());
                      snackBar(title: "예약을 취소하지 못했습니다", content: "잠시 후 다시 시도해 주세요");
                    }
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
                  "닫기",
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
