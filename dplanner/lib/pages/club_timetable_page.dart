import 'dart:io';

import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/controllers/size.dart';
import 'package:dplanner/models/reservation_model.dart';
import 'package:dplanner/style.dart';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:table_calendar/table_calendar.dart' as calendar;

import '../controllers/club.dart';
import '../models/resource_model.dart';
import '../services/reservation_api_service.dart';
import '../services/resource_api_service.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/nextpage_button.dart';
import '../widgets/outline_textform.dart';
import '../widgets/snack_bar.dart';
import '../widgets/underline_textform.dart';
import 'error_page.dart';

enum Open { yes, no }

class ClubTimetablePage extends StatefulWidget {
  const ClubTimetablePage({super.key});

  @override
  State<ClubTimetablePage> createState() => _ClubTimetablePageState();
}

class _ClubTimetablePageState extends State<ClubTimetablePage> {
  final GlobalKey<WeekViewState> weekViewStateKey = GlobalKey<WeekViewState>();
  EventController eventController = EventController();
  final List<CalendarEventData<Object?>> events = [];

  ResourceModel? selectedValue;

  final formKey1 = GlobalKey<FormState>();
  final TextEditingController title = TextEditingController();
  bool isFocused1 = false;

  final formKey2 = GlobalKey<FormState>();
  final TextEditingController usage = TextEditingController();
  bool isFocused2 = false;

  final formKey3 = GlobalKey<FormState>();
  final TextEditingController message = TextEditingController();
  bool isFocused3 = false;

  DateTime get now => DateTime.now();
  DateTime standardDay = DateTime.now();
  DateTime startOfWeek = DateTime.now();
  DateTime endOfWeek = DateTime.now();
  DateTime selectedDate = DateTime.now();

  bool checkAdminButton = false;

  @override
  void dispose() {
    title.dispose();
    usage.dispose();
    message.dispose();
    super.dispose();
  }

  Future<List<ResourceModel>> getReservations() async {
    try {
      List<List<ResourceModel>> resources =
          await ResourceApiService.getResources();
      ClubController.to.resources.value = resources[0] + resources[1];
      selectedValue ??= ClubController.to.resources.first;

      for (var i in events) {
        eventController.remove(i);
      }
      events.clear();

      int weekday = standardDay.weekday;
      startOfWeek = standardDay.subtract(Duration(days: weekday - 1));
      endOfWeek = standardDay.add(Duration(days: 7 - weekday));

      List<ReservationModel> reservations =
          await ReservationApiService.getReservations(
              resourceId: selectedValue!.id,
              startDateTime:
                  DateFormat('yyyy-MM-dd 00:00:00').format(startOfWeek),
              endDateTime: DateFormat('yyyy-MM-dd 00:00:00')
                  .format(endOfWeek.add(const Duration(days: 1))),
              status: "SCHEDULER");

      for (var i in reservations) {
        events.add(CalendarEventData(
            date: DateTime.parse(i.startDateTime),
            startTime: DateTime.parse(i.startDateTime),
            endTime: DateTime.parse(i.endDateTime)
                .subtract(const Duration(microseconds: 1)),
            title: i.status == "REQUEST"
                ? "${i.reservationId}"
                : i.title == ""
                    ? "${i.reservationId} ${i.clubMemberName}"
                    : "${i.reservationId} ${i.title}",
            description: i.status == "REQUEST"
                ? ""
                : i.title == ""
                    ? i.usage
                    : "",
            color: i.status != "CONFIRMED"
                ? AppColor.subColor4
                : i.title != ""
                    ? AppColor.subColor1
                    : AppColor.subColor3));
      }

      eventController.addAll(events);

      return ClubController.to.resources;
    } catch (e) {
      print(e.toString());
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: AppColor.backgroundColor,
            scrolledUnderElevation: 0,
            title: const Text(
              "예약 시간표",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
        ),
        body: FutureBuilder(
            future: getReservations(),
            builder: (BuildContext context,
                AsyncSnapshot<List<ResourceModel>> snapshot) {
              if (snapshot.hasData == false) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const ErrorPage();
              } else if (snapshot.data!.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: LayoutBuilder(builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        color: AppColor.backgroundColor,
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "아직 클럽 공유 물품이 없어요",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            if (MemberController.to.clubMember().role ==
                                "ADMIN")
                              Column(
                                children: [
                                  const Text(
                                    "공유 물품을 추가할까요?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.toNamed('/resource_list');
                                    },
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.pressed)) {
                                            return Colors.transparent;
                                          }
                                          return Colors.transparent;
                                        },
                                      ),
                                    ),
                                    child: const Text(
                                      "추가하기",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.objectColor),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              } else {
                return Stack(
                  children: [
                    Row(
                      children: [
                        Flexible(
                            flex: 11,
                            child: Container(color: AppColor.backgroundColor)),
                        Flexible(
                            flex: 85,
                            child: Container(color: AppColor.backgroundColor2)),
                        Flexible(
                            flex: 4,
                            child: Container(color: AppColor.backgroundColor)),
                      ],
                    ),
                    Center(
                      child: WeekView(
                        key: weekViewStateKey,
                        controller: eventController,
                        weekPageHeaderBuilder:
                            (DateTime startDate, DateTime endDate) {
                          return Container(
                            color: AppColor.backgroundColor,
                            child: Row(children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                          SizeController.to.screenWidth * 0.05,
                                      right: 32),
                                  child: WeekPageHeader(
                                    headerStringBuilder: (DateTime dateTime,
                                        {DateTime? secondaryDate}) {
                                      return DateFormat("MM월").format(dateTime);
                                    },
                                    headerStyle: HeaderStyle(
                                        decoration: BoxDecoration(
                                          color: AppColor.subColor4,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        headerPadding:
                                            const EdgeInsets.only(right: 10),
                                        headerTextStyle: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18),
                                        rightIconVisible: false,
                                        leftIcon: InkWell(
                                            onTap: () {
                                              setState(() {
                                                standardDay = now;
                                              });
                                              getReservations();
                                              weekViewStateKey.currentState
                                                  ?.jumpToWeek(now);
                                            },
                                            child: const Icon(
                                                SFSymbols.calendar_today,
                                                color: AppColor.textColor)),
                                        titleAlign: TextAlign.left),
                                    startDate: startDate,
                                    endDate: endDate,
                                    onTitleTapped: () async {
                                      await addReservation(
                                          types: 5,
                                          reservation: null,
                                          chooseDate: selectedDate);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: SizeController.to.screenWidth * 0.1),
                              Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          right: SizeController.to.screenWidth *
                                              0.05),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<ResourceModel>(
                                          isExpanded: true,
                                          items: ClubController.to.resources
                                              .map((ResourceModel resource) =>
                                                  DropdownMenuItem<
                                                      ResourceModel>(
                                                    value: resource,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        resource.name,
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColor
                                                                .textColor),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                          value: selectedValue,
                                          onChanged: (ResourceModel? value) {
                                            setState(() {
                                              selectedValue = value!;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: 50,
                                            width:
                                                SizeController.to.screenWidth *
                                                    0.1,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: AppColor.backgroundColor,
                                            ),
                                          ),
                                          iconStyleData: const IconStyleData(
                                              icon: Icon(
                                                SFSymbols.chevron_down,
                                              ),
                                              iconSize: 15,
                                              iconEnabledColor:
                                                  AppColor.textColor),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 200,
                                            width:
                                                SizeController.to.screenWidth *
                                                    0.3,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: AppColor.backgroundColor,
                                            ),
                                            direction: DropdownDirection.left,
                                            offset: const Offset(0, 50),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness: MaterialStateProperty
                                                  .all<double>(6),
                                              thumbVisibility:
                                                  MaterialStateProperty.all<
                                                      bool>(true),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                          ),
                                        ),
                                      )))
                            ]),
                          );
                        },
                        weekDayBuilder: (DateTime date) {
                          return Container(
                              color: AppColor.backgroundColor,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  (date.isAtSameMomentAs(
                                          DateTime.now().withoutTime))
                                      ? const Text(
                                          '오늘',
                                          style: TextStyle(
                                              color: AppColor.markColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15),
                                        )
                                      : (date.day == 1)
                                          ? Text(
                                              DateFormat("M/d").format(date),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15),
                                            )
                                          : Text(
                                              DateFormat.d().format(date),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15),
                                            ),
                                  (date.isAtSameMomentAs(
                                          DateTime.now().withoutTime))
                                      ? Text(
                                          DateFormat('E', 'ko_KR').format(date),
                                          style: const TextStyle(
                                              color: AppColor.markColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        )
                                      : Text(
                                          DateFormat('E', 'ko_KR').format(date),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                        )
                                ],
                              ));
                        },
                        weekTitleHeight: SizeController.to.screenHeight * 0.06,
                        weekNumberBuilder: (DateTime date) {
                          return Container(
                            color: AppColor.backgroundColor,
                          );
                        },
                        timeLineBuilder: (DateTime date) {
                          return Transform.translate(
                            offset: const Offset(0, -10),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(3, 0, 3, 42.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  // color: DateTime.now().hour == date.hour
                                  //     ? AppColor.subColor1
                                  //     : Colors.transparent,

                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                child: Text(
                                  date.hour < 10
                                      ? "0${date.hour}"
                                      : "${date.hour}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    // color: DateTime.now().hour == date.hour
                                    //     ? AppColor.textColor
                                    //     : AppColor.textColor2,
                                    color: AppColor.textColor2,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        timeLineWidth: SizeController.to.screenWidth * 0.07,
                        timeLineOffset: 0,
                        hourIndicatorSettings: const HourIndicatorSettings(
                            height: 0.7,
                            color: AppColor.backgroundColor,
                            offset: 0),
                        liveTimeIndicatorSettings:
                            const LiveTimeIndicatorSettings(
                          color: AppColor.objectColor,
                          height: 0,
                          offset: 0,
                        ),
                        eventTileBuilder: (date, events, boundry, start, end) {
                          if (events.isNotEmpty) {
                            return RoundedEventTile(
                              borderRadius: BorderRadius.circular(0.0),
                              title: events[0]
                                  .title
                                  .split(" ")
                                  .sublist(1)
                                  .join(" "),
                              titleStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColor.backgroundColor,
                                fontSize: 12,
                              ),
                              description: events[0].description,
                              descriptionStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColor.backgroundColor,
                                fontSize: 12,
                              ),
                              totalEvents: events.length,
                              padding: const EdgeInsets.all(3.0),
                              backgroundColor: events[0].color,
                            );
                          } else {
                            return Container();
                          }
                        },
                        fullDayEventBuilder: (events, date) {
                          return FullDayEventView(
                            events: events,
                            boxConstraints: const BoxConstraints(maxHeight: 65),
                            date: date,
                          );
                        },
                        pageTransitionDuration:
                            const Duration(milliseconds: 300),
                        pageTransitionCurve: Curves.linear,
                        showLiveTimeLineInAllDays: true,
                        backgroundColor: Colors.transparent,
                        minuteSlotSize: MinuteSlotSize.minutes60,
                        width: SizeController.to.screenWidth * 0.92,
                        minDay: DateTime(2020),
                        maxDay: DateTime(2030),
                        initialDay: DateTime.now(),
                        startDay: WeekDays.monday,
                        heightPerMinute:
                            SizeController.to.screenHeight * 0.0012,
                        eventArranger: const SideEventArranger(),
                        onEventTap: (events, date) async {
                          try {
                            ReservationModel reservation =
                                await ReservationApiService.getReservation(
                                    reservationId: int.parse(
                                        events[0].title.split(" ")[0]));
                            addReservation(types: 3, reservation: reservation);
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                        onDateLongPress: (date) => {},
                        onPageChange:
                            (DateTime firstDayOfWeek, int daysInWeek) {
                          setState(() {
                            standardDay = firstDayOfWeek;
                          });
                          getReservations();
                        },
                      ),
                    ),
                  ],
                );
              }
            }),
        floatingActionButton: FutureBuilder(
            future: getReservations(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData == false) {
                return const SizedBox();
              } else if (snapshot.hasError) {
                return const ErrorPage();
              } else if (snapshot.data.length == 0) {
                return const SizedBox();
              } else {
                return Visibility(
                  visible: MemberController.to.clubMember().role == "ADMIN",
                  replacement: ElevatedButton(
                    onPressed: () {
                      if (selectedValue!.notice == "") {
                        addReservation(types: 0, reservation: null);
                      } else {
                        showNotice(notice: selectedValue!.notice);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.objectColor,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Icon(
                      SFSymbols.plus,
                      color: AppColor.backgroundColor,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (checkAdminButton)
                        ElevatedButton(
                          onPressed: () {
                            //addReservation(types: 7, reservation: null);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.objectColor,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                          child: const Icon(
                            SFSymbols.lock,
                            color: AppColor.backgroundColor,
                          ),
                        ),
                      if (checkAdminButton)
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: ElevatedButton(
                            onPressed: () {
                              if (selectedValue!.notice == "") {
                                addReservation(types: 0, reservation: null);
                              } else {
                                showNotice(notice: selectedValue!.notice);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.objectColor,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(12),
                            ),
                            child: const Icon(
                              SFSymbols.plus,
                              color: AppColor.backgroundColor,
                            ),
                          ),
                        ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            checkAdminButton = !checkAdminButton;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.objectColor,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: checkAdminButton
                            ? const Icon(
                                SFSymbols.chevron_down,
                                color: AppColor.backgroundColor,
                              )
                            : const Icon(
                                SFSymbols.chevron_up,
                                color: AppColor.backgroundColor,
                              ),
                      ),
                    ],
                  ),
                );
              }
            }),
        bottomNavigationBar: const BottomBar());
  }

  /// types == 0 : 예약하기
  /// types == 1 : 예약 날짜
  /// types == 2 : 예약 시간
  /// types == 3 : 예약 정보
  /// types == 4 : 예약 수정
  /// types == 5 : 날짜 변경
  /// types == 6 : 반납하기
  /// types == 7 : 예약 잠금

  Future<void> addReservation(
      {required int types,
      required ReservationModel? reservation,
      DateTime? chooseDate}) async {
    DateTime reservationTime = chooseDate ?? now;
    DateTime focusedDay = chooseDate ?? now;
    DateTime selectedDay = chooseDate ?? now;
    int startTime = 0;
    int endTime = 0;
    bool isChecked = false;
    bool isChecked2 = false;
    Open open = Open.yes;
    title.text = "";
    usage.text = "";
    List<int> checkedTime = [];
    List<int> unableTime = [];
    List<bool> timeButton = List.generate(24, (index) => false);
    int lastType = types;
    List<XFile> selectedImages = [];
    int maxImageCount = 5;

    if (types == 3 || types == 4) {
      reservationTime = DateTime.parse(reservation!.startDateTime);
      focusedDay = reservationTime;
      selectedDay = reservationTime;
      startTime = int.parse(reservation.startDateTime.substring(11, 13));
      endTime = int.parse(reservation.endDateTime.substring(11, 13));
      for (var i = startTime; i < endTime; i++) {
        checkedTime.add(i);
        timeButton[i] = true;
      }
      title.text = reservation.title;
      usage.text = reservation.usage;
      isChecked = true;
      isChecked2 = true;
      if (!reservation.sharing) {
        open = Open.no;
      }
    }
    if (types == 5) {
      isChecked2 = true;
    }

    if (types == 6) {
      //selectedImages.clear();
    }

    bool checkTime(int newTime) {
      checkedTime.add(newTime);
      checkedTime.sort();
      for (int i = 0; i < checkedTime.length - 1; i++) {
        if ((checkedTime[i + 1] - checkedTime[i]) != 1) {
          checkedTime.remove(newTime);
          return false;
        }
      }
      return true;
    }

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
                        reservation != null && reservation.status == "REQUEST"
                            ? "승인 대기중"
                            : (types == 0)
                                ? "예약하기"
                                : (types == 1)
                                    ? "예약 날짜"
                                    : (types == 2)
                                        ? "예약 시간"
                                        : (types == 3)
                                            ? "예약 정보"
                                            : (types == 4)
                                                ? "예약 수정"
                                                : (types == 5)
                                                    ? "날짜 변경"
                                                    : "반납하기",
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
                      child: Visibility(
                        visible: !(types == 0 || types == 3 || types == 4),
                        replacement: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: !(types == 0 || types == 4),
                              replacement: Row(
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
                                    selectedValue!.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                              child: Visibility(
                                visible: reservation?.clubMemberId ==
                                    MemberController.to.clubMember().id,
                                replacement: Row(
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
                                      types == 0 ||
                                              types == 1 ||
                                              types == 2 ||
                                              reservation == null
                                          ? ""
                                          : reservation.clubMemberName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
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
                                      reservation?.status == "REQUEST"
                                          ? "승인 대기중"
                                          : reservation?.status == "CONFIRMED"
                                              ? "승인 완료"
                                              : "거절됨",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 35.0, bottom: 35.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "예약 날짜",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        if (types == 3) {
                                          null;
                                        } else {
                                          setState(() {
                                            lastType = types == 0 ? 0 : 4;
                                            types = 1;
                                          });
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(5),
                                      child: Text(
                                          DateFormat(
                                                  "yyyy. MM. dd. E요일", 'ko_KR')
                                              .format(reservationTime),
                                          style: const TextStyle(
                                              color: AppColor.textColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15))),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "예약 시간",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                InkWell(
                                    onTap: () async {
                                      if (types == 3) {
                                        null;
                                      } else {
                                        List<ReservationModel> reservations =
                                            await ReservationApiService.getReservations(
                                                resourceId: selectedValue!.id,
                                                startDateTime: DateFormat(
                                                        'yyyy-MM-dd 00:00:00')
                                                    .format(reservationTime),
                                                endDateTime: DateFormat(
                                                        'yyyy-MM-dd 00:00:00')
                                                    .format(reservationTime.add(
                                                        const Duration(
                                                            days: 1))),
                                                status: "SCHEDULER");

                                        for (var i in reservations) {
                                          if (i.reservationId !=
                                              reservation?.reservationId) {
                                            int start = int.parse(i
                                                .startDateTime
                                                .substring(11, 13));
                                            int end = int.parse(i.endDateTime
                                                .substring(11, 13));
                                            for (var j = start; j < end; j++) {
                                              unableTime.add(j);
                                            }
                                          }
                                        }
                                        setState(() {
                                          lastType = types == 0 ? 0 : 4;
                                          types = 2;
                                        });
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(5),
                                    child: Visibility(
                                      visible: checkedTime.isEmpty,
                                      replacement: Text(
                                          "$startTime:00 ~ $endTime:00 (${endTime - startTime}시간)",
                                          style: const TextStyle(
                                              color: AppColor.textColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15)),
                                      child: const Text("예약 시간을 선택해주세요",
                                          style: TextStyle(
                                              color: AppColor.textColor2,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15)),
                                    )),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Row(
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
                                      padding:
                                          const EdgeInsets.only(bottom: 14.0),
                                      child: Form(
                                          key: formKey1,
                                          child: UnderlineTextForm(
                                            hintText: '예약 제목을 입력해주세요',
                                            controller: title,
                                            isFocused: isFocused1,
                                            noLine: true,
                                            isRight: true,
                                            noErrorSign: true,
                                            isWritten:
                                                (types == 3) ? true : false,
                                            fontSize: 15,
                                            onChanged: (value) {
                                              setState(() {
                                                isFocused1 = value.isNotEmpty;
                                              });
                                            },
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "사용 용도(선택)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 14.0),
                                    child: Form(
                                        key: formKey2,
                                        child: UnderlineTextForm(
                                          hintText: '사용 용도를 입력해주세요',
                                          controller: usage,
                                          isFocused: isFocused2,
                                          noLine: true,
                                          isRight: true,
                                          noErrorSign: true,
                                          isWritten:
                                              (types == 3) ? true : false,
                                          fontSize: 15,
                                          onChanged: (value) {
                                            setState(() {
                                              isFocused2 = value.isNotEmpty;
                                            });
                                          },
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, bottom: 35.0),
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
                                  Text(
                                    types == 0 ? "선택하기" : "내용 없음",
                                    style: const TextStyle(
                                        color: AppColor.textColor2,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              "신청하신 시간에\n다른 사람이 함께 사용할 수 있나요?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            SizedBox(
                              height: SizeController.to.screenHeight * 0.05,
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
                                    const EdgeInsets.symmetric(vertical: -10.0),
                              ),
                            ),
                            SizedBox(
                              height: SizeController.to.screenHeight * 0.05,
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
                                    const EdgeInsets.symmetric(vertical: -30.0),
                              ),
                            ),
                          ],
                        ),
                        child: Visibility(
                          visible: !(types == 1 || types == 5),
                          replacement: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  types == 1
                                      ? "예약할 날짜를 선택해주세요"
                                      : "변경할 날짜를 선택해주세요",
                                  style: const TextStyle(
                                      color: AppColor.textColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ),
                              calendar.TableCalendar(
                                rowHeight:
                                    SizeController.to.screenHeight * 0.045,
                                daysOfWeekHeight:
                                    SizeController.to.screenHeight * 0.03,
                                daysOfWeekStyle: const calendar.DaysOfWeekStyle(
                                    weekdayStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.textColor),
                                    weekendStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.markColor)),
                                headerStyle: const calendar.HeaderStyle(
                                    headerPadding:
                                        EdgeInsets.fromLTRB(24, 24, 24, 12),
                                    leftChevronIcon: Icon(
                                        SFSymbols.chevron_left,
                                        color: AppColor.textColor),
                                    rightChevronIcon: Icon(
                                        SFSymbols.chevron_right,
                                        color: AppColor.textColor),
                                    titleTextStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.textColor),
                                    formatButtonTextStyle: TextStyle(
                                        fontSize: 15,
                                        color: AppColor.textColor),
                                    formatButtonVisible: false,
                                    titleCentered: true),
                                focusedDay: focusedDay,
                                firstDay: DateTime(2023, 1, 1),
                                lastDay: DateTime(2024, 12, 31),
                                locale: 'ko-KR',
                                selectedDayPredicate: (day) {
                                  return calendar.isSameDay(selectedDay, day);
                                },
                                calendarStyle: const calendar.CalendarStyle(
                                    isTodayHighlighted: false,
                                    outsideTextStyle: TextStyle(
                                        color: AppColor.textColor2,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                    defaultTextStyle: TextStyle(
                                        color: AppColor.textColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                    weekendTextStyle: TextStyle(
                                        color: AppColor.markColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                    selectedDecoration: BoxDecoration(
                                      color: AppColor.objectColor,
                                      shape: BoxShape.circle,
                                    ),
                                    selectedTextStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.backgroundColor,
                                        fontSize: 12)),
                                onDaySelected: (newSelectedDay, newFocusedDay) {
                                  setState(() {
                                    selectedDay = newSelectedDay;
                                    focusedDay = newFocusedDay;
                                    reservationTime = selectedDay;
                                    if (selectedDay.month != focusedDay.month) {
                                      focusedDay = DateTime(selectedDay.year,
                                          selectedDay.month, 1);
                                    }
                                  });
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Center(
                                  child: Text(
                                    "선택한 날짜: ${DateFormat("yyyy년 MM월 dd일 E요일", 'ko_KR').format(reservationTime)}",
                                    style: const TextStyle(
                                        color: AppColor.textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          child: Visibility(
                            visible: types != 2,
                            replacement: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "예약할 시간을 선택해주세요",
                                    style: TextStyle(
                                        color: AppColor.textColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 3, bottom: 24),
                                    child: Text(
                                      "블록 하나당 1시간입니다",
                                      style: TextStyle(
                                          color: AppColor.textColor2,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  ),
                                  GridView.count(
                                    crossAxisCount: 4,
                                    childAspectRatio: 1.8,
                                    shrinkWrap: true,
                                    children: List.generate(24, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (unableTime.contains(index)) {
                                            null;
                                          } else {
                                            setState(() {
                                              if (checkedTime.contains(index)) {
                                                timeButton[index] = false;
                                                checkedTime.remove(index);
                                                if (checkedTime.isEmpty) {
                                                  isChecked2 = false;
                                                }
                                              } else if (checkedTime.isEmpty) {
                                                timeButton[index] = true;
                                                checkedTime.add(index);
                                                isChecked2 = true;
                                              } else {
                                                if (!checkTime(index)) {
                                                  snackBar(
                                                      title: "연속된 시간을 선택해주세요",
                                                      content:
                                                          "연속된 시간만 신청 가능합니다");
                                                } else {
                                                  timeButton[index] = true;
                                                }
                                              }
                                            });
                                          }
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(2.0),
                                          decoration: BoxDecoration(
                                            color: unableTime.contains(index)
                                                ? AppColor.markColor
                                                : timeButton[index]
                                                    ? AppColor.objectColor
                                                    : AppColor.backgroundColor2,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$index:00',
                                              style: TextStyle(
                                                color: timeButton[index]
                                                    ? AppColor.backgroundColor
                                                    : AppColor.textColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  if (checkedTime.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Center(
                                        child: Text(
                                          checkedTime.length == 1
                                              ? "선택한 시간: ${checkedTime[0]}시~${checkedTime[0] + 1}시 (총 1시간)"
                                              : "선택한 시간: ${checkedTime[0]}시~${checkedTime[checkedTime.length - 1] + 1}시 (총 ${checkedTime[checkedTime.length - 1] + 1 - checkedTime[0]}시간)",
                                          style: const TextStyle(
                                              color: AppColor.textColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                ]),
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
                                    if (reservation != null)
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
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
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
                                          children: selectedImages
                                              .map<Widget>((image) {
                                            return Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 40.0),
                  child: Visibility(
                    visible: !(types == 0 || types == 4),
                    replacement: NextPageButton(
                      text: Text(
                        types == 0 ? "예약 신청하기" : "예약 수정하기",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColor.backgroundColor),
                      ),
                      buttonColor:
                          isChecked ? AppColor.objectColor : AppColor.subColor3,
                      onPressed: () async {
                        if (checkedTime.isNotEmpty) {
                          try {
                            String startDateTime = (0 <= startTime &&
                                    startTime <= 9)
                                ? DateFormat(
                                        "yyyy-MM-dd 0$startTime:00:00", 'ko_KR')
                                    .format(reservationTime)
                                : DateFormat(
                                        "yyyy-MM-dd $startTime:00:00", 'ko_KR')
                                    .format(reservationTime);
                            String endDateTime = (0 <= endTime && endTime <= 9)
                                ? DateFormat(
                                        "yyyy-MM-dd 0$endTime:00:00", 'ko_KR')
                                    .format(reservationTime)
                                : DateFormat(
                                        "yyyy-MM-dd $endTime:00:00", 'ko_KR')
                                    .format(reservationTime);
                            if (types == 0) {
                              await ReservationApiService.postReservation(
                                  resourceId: selectedValue!.id,
                                  title: title.text,
                                  usage: usage.text,
                                  sharing: (open == Open.yes) ? true : false,
                                  startDateTime: startDateTime,
                                  endDateTime: endDateTime,
                                  reservationInvitees: []);
                            } else {
                              await ReservationApiService.putReservation(
                                  reservationId: reservation!.reservationId,
                                  resourceId: selectedValue!.id,
                                  title: title.text,
                                  usage: usage.text,
                                  sharing: (open == Open.yes) ? true : false,
                                  startDateTime: startDateTime,
                                  endDateTime: endDateTime,
                                  reservationInvitees: []);
                            }
                            getReservations();
                            Get.back();
                          } catch (e) {
                            print(e.toString());
                          }
                        }
                      },
                    ),
                    child: Visibility(
                      visible: types != 3,
                      replacement: Visibility(
                        visible: reservation?.clubMemberId ==
                            MemberController.to.clubMember().id,
                        replacement: Visibility(
                          visible:
                              MemberController.to.clubMember().role == "ADMIN",
                          child: Visibility(
                            visible: reservation?.status == "REQUEST",
                            replacement: NextPageButton(
                              text: const Text(
                                "예약 삭제하기",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.backgroundColor),
                              ),
                              buttonColor: AppColor.markColor,
                              onPressed: () {
                                checkDeleteReservation(
                                    id: reservation!.reservationId, types: 0);
                              },
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 24.0, right: 24.0),
                              child: Column(
                                children: [
                                  NextPageButton(
                                    text: const Text(
                                      "예약 승인하기",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.backgroundColor),
                                    ),
                                    buttonColor: AppColor.markColor,
                                    onPressed: () async {
                                      await ReservationApiService
                                          .patchReservation(reservationIds: [
                                        reservation?.reservationId
                                      ], isConfirmed: true);
                                      getReservations();
                                      Get.back();
                                    },
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  NextPageButton(
                                    text: const Text(
                                      "예약 거절하기",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.backgroundColor),
                                    ),
                                    buttonColor: AppColor.objectColor,
                                    onPressed: () async {
                                      await ReservationApiService
                                          .patchReservation(reservationIds: [
                                        reservation?.reservationId
                                      ], isConfirmed: false);
                                      getReservations();
                                      Get.back();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        child: Visibility(
                          visible: reservation != null &&
                              DateTime.parse(reservation!.endDateTime)
                                  .isAfter(DateTime.now()),
                          replacement: NextPageButton(
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
                                types = 6;
                              });
                            },
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 24.0, right: 24.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: NextPageButton(
                                    text: const Text(
                                      "예약 취소하기",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.backgroundColor),
                                    ),
                                    buttonColor: AppColor.markColor,
                                    onPressed: () {
                                      checkDeleteReservation(
                                          id: reservation!.reservationId,
                                          types: 1);
                                    },
                                  ),
                                ),
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
                                    onPressed: () {
                                      setState(() {
                                        types = 4;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      child: Visibility(
                        visible: types != 6,
                        replacement: NextPageButton(
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
                                      reservationId: reservation!.reservationId,
                                      returnImage: selectedImages,
                                      returnMessage: message.text);
                              Get.back();
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                        ),
                        child: NextPageButton(
                          text: const Text(
                            "선택 완료",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColor.backgroundColor),
                          ),
                          buttonColor: types == 1
                              ? AppColor.objectColor
                              : isChecked2
                                  ? AppColor.objectColor
                                  : AppColor.subColor3,
                          onPressed: () {
                            if (types == 1) {
                              setState(() {
                                types = lastType;
                              });
                            } else if (types == 2 && checkedTime.isNotEmpty) {
                              setState(() {
                                isChecked = true;
                                types = lastType;
                                startTime = checkedTime[0];
                                endTime = checkedTime[0] + 1;
                                if (checkedTime.length > 1) {
                                  endTime =
                                      checkedTime[checkedTime.length - 1] + 1;
                                }
                              });
                            } else if (types == 5) {
                              setState(() {
                                selectedDate = selectedDay;
                                standardDay = selectedDate;
                              });
                              getReservations();
                              weekViewStateKey.currentState
                                  ?.jumpToWeek(selectedDate);

                              Get.back();
                            } else {
                              snackBar(
                                  title: "시간을 선택하지 않았습니다",
                                  content: "최소 한시간을 선택해주세요");
                            }
                          },
                        ),
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

  void showNotice({required String notice}) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Center(
            child: Text(
              "주의 사항",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        content: SafeArea(
          child: SingleChildScrollView(
            child: Text(
              notice,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: NextPageButton(
              text: const Text(
                "위 공지에 동의하기",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColor.backgroundColor),
              ),
              buttonColor: AppColor.objectColor,
              onPressed: () {
                Get.back();
                addReservation(types: 0, reservation: null);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// types == 0 : 삭제
  /// types == 1 : 취소
  void checkDeleteReservation({required int types, required int id}) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Center(
            child: Text(
              types == 0 ? "예약 삭제" : "예약 취소",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              types == 0 ? "한번 삭제한 예약은" : "한번 취소한 예약은",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Text(
              types == 0 ? "되살릴 수 없습니다" : "되돌릴 수 없습니다",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                types == 0 ? "정말 삭제할까요?" : "정말 취소할까요?",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
                  text: Text(
                    types == 0 ? "삭제하기" : "취소하기",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColor.backgroundColor),
                  ),
                  buttonColor: AppColor.objectColor,
                  onPressed: () async {
                    try {
                      if (types == 0) {
                        await ReservationApiService.deleteReservation(
                            reservationId: id);
                      } else {
                        await ReservationApiService.cancelReservation(
                            reservationId: id);
                      }
                      getReservations();
                      Get.back();
                      Get.back();
                    } catch (e) {
                      print(e.toString());
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
