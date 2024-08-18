import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/controllers/size.dart';
import 'package:dplanner/models/club_member_model.dart';
import 'package:dplanner/models/reservation_model.dart';
import 'package:dplanner/pages/loading_page.dart';
import 'package:dplanner/services/lock_api_service.dart';
import 'package:dplanner/const/style.dart';
import 'package:dplanner/widgets/color_unit_widget.dart';
import 'package:flutter/cupertino.dart';
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
import '../models/lock_model.dart';
import '../models/resource_model.dart';
import '../services/club_member_api_service.dart';
import '../services/reservation_api_service.dart';
import '../services/resource_api_service.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/color_scroll_widget.dart';
import '../widgets/full_screen_image.dart';
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

  final formKey4 = GlobalKey<FormState>();
  final TextEditingController lockMessage = TextEditingController();
  bool isFocused4 = false;

  DateTime get now => DateTime.now();
  DateTime standardDay = DateTime.now();
  DateTime startOfWeek = DateTime.now();
  DateTime endOfWeek = DateTime.now();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (SizeController.to.checkAdminButton) {
      SizeController.to.clickedButton();
    }
  }

  @override
  void dispose() {
    title.dispose();
    usage.dispose();
    message.dispose();
    lockMessage.dispose();
    super.dispose();
  }

  Future<List<ResourceModel>> getReservations() async {
    try {
      // 클럽 자원 불러오기
      List<List<ResourceModel>> resources =
          await ResourceApiService.getResources();
      ClubController.to.resources.value = resources[0] + resources[1];
      selectedValue ??= ClubController.to.resources.first;

      // 이벤트 초기화
      for (var i in events) {
        eventController.remove(i);
      }
      events.clear();

      // 지금 페이지 이벤트 불러오기
      int weekday = standardDay.weekday;
      startOfWeek = standardDay.subtract(Duration(days: weekday - 1));
      endOfWeek = standardDay.add(Duration(days: 7 - weekday + 1));
      DateTime endOfResource = DateTime.now();
      endOfResource =
          DateTime(endOfResource.year, endOfResource.month, endOfResource.day)
              .add(Duration(days: selectedValue!.bookableSpan! + 1));

      DateTime endDate = !(MemberController.to.clubMember().role == "ADMIN" ||
                  (MemberController.to.clubMember().clubAuthorityTypes !=
                          null &&
                      MemberController.to
                          .clubMember()
                          .clubAuthorityTypes!
                          .contains("SCHEDULE_ALL"))) &&
              ((endOfResource.isBefore(endOfWeek) ||
                  endOfResource.isAfter(startOfWeek)))
          ? endOfResource
          : endOfWeek;

      if (startOfWeek.isBefore(endDate)) {
        List<ReservationModel> reservations =
            await ReservationApiService.getReservations(
                resourceId: selectedValue!.id,
                startDateTime:
                    DateFormat('yyyy-MM-dd 00:00:00').format(startOfWeek),
                endDateTime: DateFormat('yyyy-MM-dd 00:00:00').format(endDate));

        List<LockModel> locks = await LockApiService.getLocks(
            resourceId: selectedValue!.id,
            startDateTime:
                DateFormat('yyyy-MM-dd 00:00:00').format(startOfWeek),
            endDateTime: DateFormat('yyyy-MM-dd 00:00:00').format(endDate));

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
              color: i.status == "REQUEST"
                  ? (i.clubMemberId == MemberController.to.clubMember().id
                      ? AppColor.subColor2
                      : AppColor.subColor4)
                  : AppColor.ofHex(i.color) // 승인된 예약만 설정한대로

                  // 나중에 쓸수도 있어서 남겨둠(나와 관련된 예약 하이라이트 같은 기능)
                  // : (i.clubMemberId == MemberController.to.clubMember().id ||
                  //         i.invitees.any((element) =>
                  //             element["clubMemberId"] ==
                  //                 MemberController.to.clubMember().id &&
                  //             element["clubMemberName"] ==
                  //                 MemberController.to.clubMember().name))
                  //     ? AppColor.subColor1
                  //     : AppColor.subColor3
          ));
        }

        for (var i in locks) {
          DateTime startDate = DateTime.parse(i.startDateTime);
          DateTime endDate = DateTime.parse(i.endDateTime);

          for (DateTime j = startDate;
              j.isBefore(endDate);
              j = j.add(const Duration(days: 1))) {
            DateTime startTime = (j.year == startDate.year &&
                    j.month == startDate.month &&
                    j.day == startDate.day)
                ? startDate
                : DateTime(startDate.year, startDate.month, startDate.day);
            DateTime endTime = (j.year == endDate.year &&
                    j.month == endDate.month &&
                    j.day == endDate.day)
                ? endDate
                : DateTime(endDate.year, endDate.month, endDate.day);
            events.add(CalendarEventData(
                date: j,
                startTime: startTime,
                endTime: endTime.subtract(const Duration(microseconds: 1)),
                title: "",
                description: "",
                color: AppColor.lockColor.withOpacity(0.5)));
          }
        }
      }

      if (!(MemberController.to.clubMember().role == "ADMIN" ||
              (MemberController.to.clubMember().clubAuthorityTypes != null &&
                  MemberController.to
                      .clubMember()
                      .clubAuthorityTypes!
                      .contains("SCHEDULE_ALL"))) &&
          (endOfWeek.isAfter(endOfResource))) {
        for (DateTime j = endOfResource;
            j.isBefore(endOfWeek.add(const Duration(days: 1)));
            j = j.add(const Duration(days: 1))) {
          events.add(CalendarEventData(
              date: j,
              startTime:
                  DateTime.parse(DateFormat('yyyy-MM-dd 00:00:00').format(j)),
              endTime:
                  DateTime.parse(DateFormat('yyyy-MM-dd 23:59:59').format(j)),
              title: "",
              description: "",
              color: AppColor.lockColor.withOpacity(0.5)));
        }
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
        body: SafeArea(
          child: FutureBuilder(
              future: getReservations(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ResourceModel>> snapshot) {
                if (snapshot.hasData == false) {
                  return const LoadingPage();
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
                        child: Column(
                          children: [
                            const BannerAdWidget(),
                            Container(
                              color: AppColor.backgroundColor,
                              height: constraints.maxHeight - 50,
                              width: constraints.maxWidth,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "아직 클럽 공유 물품이 없어요",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  ),
                                  if (MemberController.to.clubMember().role ==
                                          "ADMIN" ||
                                      (MemberController.to
                                                  .clubMember()
                                                  .clubAuthorityTypes !=
                                              null &&
                                          MemberController.to
                                              .clubMember()
                                              .clubAuthorityTypes!
                                              .contains("RESOURCE_ALL")))
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
                          ],
                        ),
                      );
                    }),
                  );
                } else {
                  return Column(
                    children: [
                      const BannerAdWidget(),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                    flex: 11,
                                    child: Container(
                                        color: AppColor.backgroundColor)),
                                Flexible(
                                    flex: 85,
                                    child: Container(
                                        color: AppColor.backgroundColor2)),
                                Flexible(
                                    flex: 4,
                                    child: Container(
                                        color: AppColor.backgroundColor)),
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
                                              left: SizeController
                                                      .to.screenWidth *
                                                  0.05,
                                              right: SizeController
                                                      .to.screenWidth *
                                                  0.1),
                                          child: WeekPageHeader(
                                            headerStringBuilder:
                                                (DateTime dateTime,
                                                    {DateTime? secondaryDate}) {
                                              return DateFormat(" MM월")
                                                  .format(dateTime);
                                            },
                                            headerStyle: HeaderStyle(
                                                decoration: BoxDecoration(
                                                  color: AppColor.subColor4,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                headerTextStyle:
                                                    const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 18),
                                                rightIconVisible: false,
                                                leftIcon: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        standardDay = now;
                                                      });
                                                      getReservations();
                                                      weekViewStateKey
                                                          .currentState
                                                          ?.jumpToWeek(now);
                                                    },
                                                    child: const Icon(
                                                        SFSymbols.calendar,
                                                        color: AppColor
                                                            .textColor)),
                                                titleAlign: TextAlign.start),
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
                                      Expanded(
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: SizeController
                                                          .to.screenWidth *
                                                      0.02),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton2<
                                                    ResourceModel>(
                                                  isExpanded: true,
                                                  items: ClubController
                                                      .to.resources
                                                      .map((ResourceModel
                                                              resource) =>
                                                          DropdownMenuItem<
                                                              ResourceModel>(
                                                            value: resource,
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                resource.name,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: AppColor
                                                                        .textColor),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ))
                                                      .toList(),
                                                  value: selectedValue,
                                                  onChanged:
                                                      (ResourceModel? value) {
                                                    setState(() {
                                                      selectedValue = value!;
                                                    });
                                                  },
                                                  buttonStyleData:
                                                      ButtonStyleData(
                                                    height: 40,
                                                    width: SizeController
                                                            .to.screenWidth *
                                                        0.1,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: AppColor
                                                          .backgroundColor,
                                                    ),
                                                  ),
                                                  iconStyleData:
                                                      const IconStyleData(
                                                          icon: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8,
                                                                    right: 8),
                                                            child: Icon(SFSymbols
                                                                .chevron_down),
                                                          ),
                                                          iconSize: 15,
                                                          iconEnabledColor:
                                                              AppColor
                                                                  .textColor),
                                                  dropdownStyleData:
                                                      DropdownStyleData(
                                                    maxHeight: 200,
                                                    width: SizeController
                                                            .to.screenWidth *
                                                        0.3,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: AppColor
                                                          .backgroundColor,
                                                    ),
                                                    direction:
                                                        DropdownDirection.left,
                                                    offset: const Offset(0, 40),
                                                    scrollbarTheme:
                                                        ScrollbarThemeData(
                                                      radius:
                                                          const Radius.circular(
                                                              40),
                                                      thickness:
                                                          MaterialStateProperty
                                                              .all<double>(6),
                                                      thumbVisibility:
                                                          MaterialStateProperty
                                                              .all<bool>(true),
                                                    ),
                                                  ),
                                                  menuItemStyleData:
                                                      const MenuItemStyleData(
                                                    height: 32,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          (date.isAtSameMomentAs(
                                                  DateTime.now().withoutTime))
                                              ? const Text(
                                                  '오늘',
                                                  style: TextStyle(
                                                      color: AppColor.markColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 15),
                                                )
                                              : (date.day == 1)
                                                  ? Text(
                                                      DateFormat("M/d")
                                                          .format(date),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 15),
                                                    )
                                                  : Text(
                                                      DateFormat.d()
                                                          .format(date),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 15),
                                                    ),
                                          (date.isAtSameMomentAs(
                                                  DateTime.now().withoutTime))
                                              ? Text(
                                                  DateFormat('E', 'ko_KR')
                                                      .format(date),
                                                  style: const TextStyle(
                                                      color: AppColor.markColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12),
                                                )
                                              : Text(
                                                  DateFormat('E', 'ko_KR')
                                                      .format(date),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12),
                                                )
                                        ],
                                      ));
                                },
                                weekTitleHeight:
                                    SizeController.to.screenHeight * 0.06,
                                weekNumberBuilder: (DateTime date) {
                                  return Container(
                                    color: AppColor.backgroundColor,
                                  );
                                },
                                timeLineBuilder: (DateTime date) {
                                  return Text(
                                    date.hour < 10
                                        ? "0${date.hour}"
                                        : "${date.hour}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppColor.textColor2,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                    ),
                                  );
                                },
                                timeLineWidth:
                                    SizeController.to.screenWidth * 0.07,
                                timeLineOffset: 10,
                                hourIndicatorSettings:
                                    const HourIndicatorSettings(
                                        height: 0.7,
                                        color: AppColor.backgroundColor,
                                        offset: 0),
                                liveTimeIndicatorSettings:
                                    const LiveTimeIndicatorSettings(
                                  color: AppColor.objectColor,
                                  height: 1,
                                  offset: 1,
                                ),
                                eventTileBuilder:
                                    (date, events, boundry, start, end) {
                                  if (events.isNotEmpty) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: events[0].color ==
                                                      AppColor.subColor4 &&
                                                  (MemberController.to
                                                              .clubMember()
                                                              .role ==
                                                          "ADMIN" ||
                                                      (MemberController.to
                                                                  .clubMember()
                                                                  .clubAuthorityTypes !=
                                                              null &&
                                                          MemberController.to
                                                              .clubMember()
                                                              .clubAuthorityTypes!
                                                              .contains(
                                                                  "SCHEDULE_ALL")))
                                              ? AppColor.objectColor
                                              : Colors.transparent,
                                          width: events[0].color ==
                                                      AppColor.subColor4 &&
                                                  (MemberController.to
                                                              .clubMember()
                                                              .role ==
                                                          "ADMIN" ||
                                                      (MemberController.to
                                                                  .clubMember()
                                                                  .clubAuthorityTypes !=
                                                              null &&
                                                          MemberController.to
                                                              .clubMember()
                                                              .clubAuthorityTypes!
                                                              .contains(
                                                                  "SCHEDULE_ALL")))
                                              ? 2.0
                                              : 0.0,
                                        ),
                                      ),
                                      child: RoundedEventTile(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        title: events[0]
                                            .title
                                            .split(" ")
                                            .sublist(1)
                                            .join(" "),
                                        titleStyle: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.backgroundColor,
                                            fontSize: 12,
                                            wordSpacing: 20),
                                        description: events[0].description,
                                        descriptionStyle: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: AppColor.backgroundColor,
                                          fontSize: 12,
                                        ),
                                        totalEvents: events.length,
                                        padding: const EdgeInsets.all(3.0),
                                        backgroundColor: events[0].color,
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                                fullDayEventBuilder: (events, date) {
                                  return FullDayEventView(
                                    events: events,
                                    boxConstraints:
                                        const BoxConstraints(maxHeight: 65),
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
                                  if (events[0].title != "") {
                                    try {
                                      ReservationModel reservation =
                                          await ReservationApiService
                                              .getReservation(
                                                  reservationId: int.parse(
                                                      events[0]
                                                          .title
                                                          .split(" ")[0]));
                                      addReservation(
                                          types: 3, reservation: reservation);
                                    } catch (e) {
                                      print(e.toString());
                                    }
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
                        ),
                      ),
                    ],
                  );
                }
              }),
        ),
        floatingActionButton: FutureBuilder(
            future: getReservations(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData == false || snapshot.data.length == 0) {
                return const SizedBox();
              } else if (snapshot.hasError) {
                return const ErrorPage();
              } else {
                return Visibility(
                  visible: (MemberController.to.clubMember().role == "ADMIN" ||
                      (MemberController.to.clubMember().clubAuthorityTypes !=
                              null &&
                          MemberController.to
                              .clubMember()
                              .clubAuthorityTypes!
                              .contains("SCHEDULE_ALL"))),
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
                  child: GetBuilder<SizeController>(
                    builder: (controller) => Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (SizeController.to.checkAdminButton)
                            ElevatedButton(
                              onPressed: () {
                                addReservation(types: 7, reservation: null);
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
                          if (SizeController.to.checkAdminButton)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
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
                            onPressed: () => controller.clickedButton(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.objectColor,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                            ),
                            child: controller.checkAdminButton
                                ? const Icon(
                                    SFSymbols.chevron_down,
                                    color: AppColor.backgroundColor,
                                  )
                                : const Icon(
                                    SFSymbols.chevron_up,
                                    color: AppColor.backgroundColor,
                                  ),
                          ),
                        ]),
                  ),
                );
              }
            }),
        bottomNavigationBar: const BottomBar());
  }

  /// types == 0 : 예약 하기
  /// types == 1 : 예약 날짜
  /// types == 2 : 예약 시간
  /// types == 3 : 예약 정보
  /// types == 4 : 예약 수정
  /// types == 5 : 날짜 변경
  /// types == 6 : 반납 하기
  /// types == 7 : 잠금 정보
  /// types == 8 : 잠금 수정
  /// types == 9 : 멤버 선택
  /// types == 10 : 예약자 선택

  Future<void> addReservation(
      {required int types,
      required ReservationModel? reservation,
      DateTime? chooseDate}) async {
    DateTime reservationTime = chooseDate ?? now;
    DateTime focusedDay = chooseDate ?? now;
    DateTime selectedDay = chooseDate ?? now;

    List<Map<String, dynamic>> invitees = [];
    List<Map<String, dynamic>> updateInvitees = [];
    Map<String, dynamic> owner = {
      'clubMemberName': MemberController.to.clubMember().name,
      'clubMemberId': MemberController.to.clubMember().id
    };
    Map<String, dynamic> updateOwner = {
      'clubMemberName': MemberController.to.clubMember().name,
      'clubMemberId': MemberController.to.clubMember().id
    };
    List<bool> isChecked = [];

    int startTime = -1;
    int endTime = -1;

    bool isChecked1 = false;
    bool isChecked2 = false;

    Open open = Open.yes;
    title.text = "";
    usage.text = "";
    List<int> checkedTime = [];
    List<int> unableTime = [];
    List<bool> timeButton = List.generate(24, (index) => false);
    List<XFile> selectedImages = [];
    int maxImageCount = 5;
    List<int> lastPages = [];

    DateTime lockStartDate = now;
    DateTime lockEndDate = now;
    int lockStartTime = -1;
    int lockEndTime = -1;
    int checkedLock = -1;
    DateTime updateStartDate = now;
    DateTime updateEndDate = now;
    int updateStartTime = -1;
    LockModel? lock;

    bool checkedMore = false;
    bool checkedReturn = false;

    int weekday = standardDay.weekday;
    startOfWeek = standardDay.subtract(Duration(days: weekday - 1));
    String dateOfLock = DateFormat('yyyy년 MM월').format(startOfWeek);

    Color selectedColor = reservation == null
        ? AppColor.reservationColors[0]
        : AppColor.ofHex(reservation.color);

    if (types == 3) {
      reservationTime = DateTime.parse(reservation!.startDateTime);
      focusedDay = reservationTime;
      selectedDay = reservationTime;
      startTime = int.parse(reservation.startDateTime.substring(11, 13));
      endTime = int.parse(reservation.endDateTime.substring(11, 13));
      if (endTime == 00) {
        endTime = 24;
      }
      invitees.addAll(reservation.invitees);
      for (var i = startTime; i < endTime; i++) {
        checkedTime.add(i);
        timeButton[i] = true;
      }
      title.text = reservation.title;
      usage.text = reservation.usage;
      isChecked1 = true;
      isChecked2 = true;
      if (!reservation.sharing) {
        open = Open.no;
      }
      try {
        ClubMemberModel reservationOwner =
            await ClubMemberApiService.getClubMember(
                clubId: ClubController.to.club().id,
                clubMemberId: reservation.clubMemberId);
        owner = {
          'clubMemberName': reservationOwner.name,
          'clubMemberId': reservationOwner.id
        };
      } catch (e) {
        snackBar(title: "예약 정보를 불러오는데 오류가 발생하였습니다.", content: "개발자에게 문의해주세요");
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

    Future<List<LockModel>> getLockList(StateSetter setState) async {
      try {
        DateTime startOfMonth =
            DateTime(startOfWeek.year, startOfWeek.month, 1);
        DateTime endOfMonth =
            DateTime(startOfWeek.year, startOfWeek.month + 1, 0);
        String startTimeLock =
            DateFormat('yyyy-MM-dd 00:00:00').format(startOfMonth);
        String endTimeLock = DateFormat('yyyy-MM-dd 00:00:00')
            .format(endOfMonth.add(const Duration(days: 1)));
        List<LockModel> locks = await LockApiService.getLocks(
            resourceId: selectedValue!.id,
            startDateTime: startTimeLock,
            endDateTime: endTimeLock);
        return locks;
      } catch (e) {
        print(e.toString());
      }
      return [];
    }

    Future<List<ClubMemberModel>> getMemberList(StateSetter setState) async {
      try {
        List<ClubMemberModel> members =
            await ClubMemberApiService.getClubMemberList(
                clubId: ClubController.to.club().id, confirmed: true);
        List<ClubMemberModel> removeMeMembers = members;
        if (types == 9) {
          removeMeMembers = members
              .where(
                  (member) => member.id != MemberController.to.clubMember().id)
              .toList();
        }

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
          return SafeArea(
            child: SizedBox(
              height: SizeController.to.screenHeight * 0.7,
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 8.0, bottom: 16.0),
                          child: SvgPicture.asset(
                            'assets/images/extra/showmodal_scrollcontrolbar.svg',
                          ),
                        ),
                        Stack(
                          children: [
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    reservation != null &&
                                            reservation.status == "REQUEST" &&
                                            (MemberController.to
                                                        .clubMember()
                                                        .role ==
                                                    "ADMIN" ||
                                                (MemberController.to
                                                            .clubMember()
                                                            .clubAuthorityTypes !=
                                                        null &&
                                                    MemberController.to
                                                        .clubMember()
                                                        .clubAuthorityTypes!
                                                        .contains(
                                                            "SCHEDULE_ALL")))
                                        ? "예약 요청"
                                        : reservation?.status == "REQUEST"
                                            ? "승인 대기중"
                                            : (types == 0)
                                                ? "예약하기"
                                                : (types == 1 &&
                                                        lastPages.last == 0)
                                                    ? "예약 날짜"
                                                    : (types == 1)
                                                        ? "잠금 날짜"
                                                        : (types == 2 &&
                                                                lastPages
                                                                        .last ==
                                                                    0)
                                                            ? "예약 시간"
                                                            : (types == 2)
                                                                ? "잠금 시간"
                                                                : (types == 3)
                                                                    ? "예약 정보"
                                                                    : (types ==
                                                                            4)
                                                                        ? "예약 수정"
                                                                        : (types ==
                                                                                5)
                                                                            ? "날짜 변경"
                                                                            : (types == 6)
                                                                                ? "반납하기"
                                                                                : (types == 7)
                                                                                    ? "예약 잠금"
                                                                                    : (types == 8 && lock == null)
                                                                                        ? "예약 잠금 추가"
                                                                                        : (types == 9)
                                                                                            ? "함께 사용하는 사람"
                                                                                            : (types == 10)
                                                                                                ? "예약자"
                                                                                                : "예약 잠금 정보",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                if (types == 7)
                                  Text(
                                    "[$dateOfLock]",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.textColor),
                                  ),
                              ],
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
                                          : reservation?.status ==
                                                      "CONFIRMED" &&
                                                  !reservation!.returned
                                              ? "승인 완료"
                                              : reservation?.status ==
                                                          "CONFIRMED" &&
                                                      reservation!.returned
                                                  ? "승인 및 반납 완료"
                                                  : "거절됨",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 32.0),
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
                                    GestureDetector(
                                      onTap: () {
                                        if ((MemberController.to
                                                        .clubMember()
                                                        .role ==
                                                    "ADMIN" ||
                                                (MemberController.to
                                                            .clubMember()
                                                            .clubAuthorityTypes !=
                                                        null &&
                                                    MemberController.to
                                                        .clubMember()
                                                        .clubAuthorityTypes!
                                                        .contains(
                                                            "SCHEDULE_ALL"))) &&
                                            (types == 0 || types == 4)) {
                                          setState(() {
                                            isChecked.clear();
                                            updateOwner = owner;
                                            lastPages.add(types);
                                            types = 10;
                                          });
                                        }
                                      },
                                      child: Text(
                                        (types == 0 || types == 4) &&
                                                owner.isEmpty
                                            ? "선택하기"
                                            : "${owner["clubMemberName"]}",
                                        style: TextStyle(
                                            color: owner.isNotEmpty
                                                ? AppColor.textColor
                                                : AppColor.textColor2,
                                            fontWeight: owner.isNotEmpty
                                                ? FontWeight.w500
                                                : FontWeight.w400,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 32.0, bottom: 32.0),
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
                                    GestureDetector(
                                        onTap: () {
                                          if (types == 3) {
                                            null;
                                          } else if (types == 4) {
                                            snackBar(
                                                title: "예약 날짜는 수정 불가능합니다",
                                                content:
                                                    "날짜를 변경하고 싶으시다면 새로 예약해주세요");
                                          } else {
                                            setState(() {
                                              selectedDay = reservationTime;
                                              lastPages.add(0);
                                              types = 1;
                                            });
                                          }
                                        },
                                        child: Text(
                                            DateFormat("yyyy. MM. dd. E요일",
                                                    'ko_KR')
                                                .format(reservationTime),
                                            style: const TextStyle(
                                                color: AppColor.textColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15))),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "예약 시간",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  GestureDetector(
                                      onTap: () async {
                                        if (types == 3) {
                                          null;
                                        } else if (types == 4) {
                                          snackBar(
                                              title: "예약 시간은 수정 불가능합니다",
                                              content:
                                                  "시간을 변경하고 싶으시다면 새로 예약해주세요");
                                        } else {
                                          unableTime.clear();

                                          // 일반 사용자의 경우 지난 시간 제외
                                          if (!(MemberController.to
                                                      .clubMember()
                                                      .role ==
                                                  "ADMIN" ||
                                              (MemberController.to
                                                          .clubMember()
                                                          .clubAuthorityTypes !=
                                                      null &&
                                                  MemberController.to
                                                      .clubMember()
                                                      .clubAuthorityTypes!
                                                      .contains(
                                                          "SCHEDULE_ALL")))) {
                                            if (reservationTime
                                                    .isBefore(DateTime.now()) ||
                                                reservationTime.day ==
                                                    DateTime.now().day) {
                                              for (var j = 0;
                                                  j <= DateTime.now().hour;
                                                  j++) {
                                                unableTime.add(j);
                                              }
                                            }
                                          }

                                          // 기존 예약 시간 제외
                                          List<ReservationModel> reservations =
                                              await ReservationApiService.getReservations(
                                                  resourceId: selectedValue!.id,
                                                  startDateTime: DateFormat(
                                                          'yyyy-MM-dd 00:00:00')
                                                      .format(reservationTime),
                                                  endDateTime: DateFormat(
                                                          'yyyy-MM-dd 00:00:00')
                                                      .format(reservationTime
                                                          .add(const Duration(
                                                              days: 1))));

                                          for (var i in reservations) {
                                            if (i.reservationId !=
                                                reservation?.reservationId) {
                                              int start = int.parse(i
                                                  .startDateTime
                                                  .substring(11, 13));
                                              int end = int.parse(i.endDateTime
                                                  .substring(11, 13));
                                              if (end == 0) {
                                                // 다음날 00으로 설정 되어 있을 경우 24로 설정
                                                end = 24;
                                              }
                                              for (var j = start;
                                                  j < end;
                                                  j++) {
                                                unableTime.add(j);
                                              }
                                            }
                                          }

                                          // 기존 락 시간 제외
                                          List<LockModel> locks =
                                              await LockApiService.getLocks(
                                                  resourceId: selectedValue!.id,
                                                  startDateTime: DateFormat(
                                                          'yyyy-MM-dd 00:00:00')
                                                      .format(reservationTime),
                                                  endDateTime: DateFormat(
                                                          'yyyy-MM-dd 00:00:00')
                                                      .format(reservationTime
                                                          .add(const Duration(
                                                              days: 1))));

                                          for (var i in locks) {
                                            DateTime startDate =
                                                DateTime.parse(i.startDateTime);
                                            DateTime endDate =
                                                DateTime.parse(i.endDateTime);
                                            bool isStart = startDate.year ==
                                                    reservationTime.year &&
                                                startDate.month ==
                                                    reservationTime.month &&
                                                startDate.day ==
                                                    reservationTime.day;
                                            bool isEnd = endDate.year ==
                                                    reservationTime.year &&
                                                endDate.month ==
                                                    reservationTime.month &&
                                                endDate.day ==
                                                    reservationTime.day;
                                            int start = 0;
                                            int end = 24;
                                            if (isStart && isEnd) {
                                              start = int.parse(i.startDateTime
                                                  .substring(11, 13));
                                              end = int.parse(i.endDateTime
                                                  .substring(11, 13));
                                            } else if (isStart) {
                                              start = int.parse(i.startDateTime
                                                  .substring(11, 13));
                                              end = 24;
                                            } else if (isEnd) {
                                              start = 0;
                                              end = int.parse(i.endDateTime
                                                  .substring(11, 13));
                                            }
                                            for (var j = start; j < end; j++) {
                                              unableTime.add(j);
                                            }
                                          }

                                          setState(() {
                                            lastPages.add(0);
                                            types = 2;
                                          });
                                        }
                                      },
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
                                        types == 3
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
                              Visibility(
                                visible: types == 3,
                                replacement: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                                types = 9;
                                              });
                                            },
                                            child: Text(
                                              (types == 0 || types == 4) &&
                                                      invitees.isEmpty
                                                  ? "선택하기"
                                                  : invitees.isNotEmpty &&
                                                          invitees.length >= 2
                                                      ? "${invitees[0]["clubMemberName"]} 외 ${invitees.length - 1}명"
                                                      : invitees
                                                          .map((invitee) =>
                                                              invitee["clubMemberName"]
                                                                  as String)
                                                          .join(", "),
                                              style: TextStyle(
                                                  color: invitees.isNotEmpty
                                                      ? AppColor.textColor
                                                      : AppColor.textColor2,
                                                  fontWeight:
                                                      invitees.isNotEmpty
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
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 32.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            checkedMore = !checkedMore;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            const Text(
                                              "예약 정보 더보기",
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
                                    if (checkedMore && reservation!.title != "")
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
                                    if (checkedMore && reservation!.usage != "")
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
                                        reservation!.invitees.isNotEmpty)
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
                                                    String inviteesNames = invitees
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
                                                          style:
                                                              const TextStyle(
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
                                                invitees.length >= 2
                                                    ? "${invitees[0]["clubMemberName"]} 외 ${invitees.length - 1}명"
                                                    : invitees
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
                                              reservation!.sharing
                                                  ? "가능"
                                                  : "불가능",
                                              style: const TextStyle(
                                                  color: AppColor.textColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (reservation != null &&
                                        reservation.returned &&
                                        (MemberController.to
                                                    .clubMember()
                                                    .role ==
                                                "ADMIN" ||
                                            (MemberController.to
                                                        .clubMember()
                                                        .clubAuthorityTypes !=
                                                    null &&
                                                MemberController.to
                                                    .clubMember()
                                                    .clubAuthorityTypes!
                                                    .contains(
                                                        "RETURN_MSG_READ")) ||
                                            reservation.clubMemberId ==
                                                MemberController.to
                                                    .clubMember()
                                                    .id))
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 32.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  checkedReturn =
                                                      !checkedReturn;
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
                                                        : SFSymbols
                                                            .chevron_down,
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
                                                            const EdgeInsets
                                                                .only(
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
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    child: CachedNetworkImage(
                                                                        placeholder: (context, url) => Container(),
                                                                        imageUrl: formattedUrl,
                                                                        errorWidget: (context, url, error) => SvgPicture.asset(
                                                                              'assets/images/base_image/base_post_image.svg',
                                                                            ),
                                                                        fit: BoxFit.cover)),
                                                              ),
                                                              Positioned.fill(
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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
                                                                            .withOpacity(0.9),
                                                                        AppColor
                                                                            .objectColor
                                                                            .withOpacity(0.7),
                                                                        AppColor
                                                                            .objectColor
                                                                            .withOpacity(0.5),
                                                                        AppColor
                                                                            .objectColor
                                                                            .withOpacity(0.3),
                                                                        AppColor
                                                                            .objectColor
                                                                            .withOpacity(0.1),
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
                                              reservation.returnMessage !=
                                                  null &&
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
                                                  reservation.returnMessage ??
                                                      "",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                            visible: !(types == 1 || types == 5),
                            replacement: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    types == 1 && lastPages.last == 0
                                        ? "예약할 날짜를 선택해주세요"
                                        : types == 5
                                            ? "변경할 날짜를 선택해주세요"
                                            : types == 1 && lastPages.last == 2
                                                ? "잠금 종료 날짜를 선택해주세요"
                                                : "잠금 시작 날짜를 선택해주세요",
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
                                  daysOfWeekStyle:
                                      const calendar.DaysOfWeekStyle(
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
                                  rangeSelectionMode: (types == 1 &&
                                          !(MemberController.to
                                                      .clubMember()
                                                      .role ==
                                                  "ADMIN" ||
                                              (MemberController.to
                                                          .clubMember()
                                                          .clubAuthorityTypes !=
                                                      null &&
                                                  MemberController.to
                                                      .clubMember()
                                                      .clubAuthorityTypes!
                                                      .contains(
                                                          "SCHEDULE_ALL"))))
                                      ? calendar.RangeSelectionMode.toggledOn
                                      : calendar.RangeSelectionMode.disabled,
                                  rangeStartDay: (types == 1 &&
                                          !(MemberController.to
                                                      .clubMember()
                                                      .role ==
                                                  "ADMIN" ||
                                              (MemberController.to
                                                          .clubMember()
                                                          .clubAuthorityTypes !=
                                                      null &&
                                                  MemberController.to
                                                      .clubMember()
                                                      .clubAuthorityTypes!
                                                      .contains(
                                                          "SCHEDULE_ALL"))))
                                      ? DateTime.now()
                                      : null,
                                  rangeEndDay: (types == 1 &&
                                          !(MemberController.to
                                                      .clubMember()
                                                      .role ==
                                                  "ADMIN" ||
                                              (MemberController.to
                                                          .clubMember()
                                                          .clubAuthorityTypes !=
                                                      null &&
                                                  MemberController.to
                                                      .clubMember()
                                                      .clubAuthorityTypes!
                                                      .contains(
                                                          "SCHEDULE_ALL"))))
                                      ? DateTime.now().add(Duration(
                                          days: selectedValue!.bookableSpan!))
                                      : null,
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
                                          fontSize: 12),
                                      rangeHighlightColor: AppColor.subColor2,
                                      rangeStartDecoration: BoxDecoration(
                                        color: AppColor.subColor2,
                                        shape: BoxShape.circle,
                                      ),
                                      rangeStartTextStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.backgroundColor,
                                          fontSize: 12),
                                      rangeEndDecoration: BoxDecoration(
                                        color: AppColor.subColor2,
                                        shape: BoxShape.circle,
                                      ),
                                      rangeEndTextStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.backgroundColor,
                                          fontSize: 12),
                                      withinRangeDecoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                      withinRangeTextStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.backgroundColor,
                                          fontSize: 12)),
                                  onDaySelected:
                                      (newSelectedDay, newFocusedDay) {
                                    setState(() {
                                      DateTime rangeStart = DateTime.now();
                                      DateTime rangeEnd = DateTime.now().add(
                                          Duration(
                                              days:
                                                  selectedValue!.bookableSpan! +
                                                      1));
                                      if (types == 5) {
                                        // 날짜 선택
                                        selectedDay = newSelectedDay;
                                        focusedDay = newFocusedDay;
                                        chooseDate = selectedDay;
                                        if (selectedDay.month !=
                                            focusedDay.month) {
                                          focusedDay = DateTime(
                                              selectedDay.year,
                                              selectedDay.month,
                                              1);
                                        }
                                      } else {
                                        if (MemberController.to
                                                    .clubMember()
                                                    .role ==
                                                "ADMIN" ||
                                            (MemberController.to
                                                        .clubMember()
                                                        .clubAuthorityTypes !=
                                                    null &&
                                                MemberController.to
                                                    .clubMember()
                                                    .clubAuthorityTypes!
                                                    .contains(
                                                        "SCHEDULE_ALL"))) {
                                          selectedDay = newSelectedDay;
                                          focusedDay = newFocusedDay;
                                          if (selectedDay.month !=
                                              focusedDay.month) {
                                            focusedDay = DateTime(
                                                selectedDay.year,
                                                selectedDay.month,
                                                1);
                                          } else if (lastPages.last != 0) {
                                            reservationTime = selectedDay;
                                          }
                                        } else {
                                          if (newSelectedDay
                                                      .isAfter(rangeStart) &&
                                                  newSelectedDay
                                                      .isBefore(rangeEnd) ||
                                              newSelectedDay == rangeStart ||
                                              newSelectedDay == rangeEnd) {
                                            selectedDay = newSelectedDay;
                                            focusedDay = newFocusedDay;
                                            if (selectedDay.month !=
                                                focusedDay.month) {
                                              focusedDay = DateTime(
                                                  selectedDay.year,
                                                  selectedDay.month,
                                                  1);
                                            } else if (lastPages.last != 0) {
                                              reservationTime = selectedDay;
                                            }
                                          } else {
                                            snackBar(
                                                title: "선택할 수 없는 날짜입니다",
                                                content: "선택 가능한 날짜를 선택해주세요");
                                          }
                                        }
                                      }
                                    });
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Center(
                                    child: Text(
                                      "선택한 날짜: ${DateFormat("yyyy년 MM월 dd일 E요일", 'ko_KR').format(selectedDay)}",
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
                                    Text(
                                      types == 2 && lastPages.last == 0
                                          ? "예약할 시간을 선택해주세요"
                                          : types == 2 &&
                                                  lastPages[lastPages.length -
                                                          2] !=
                                                      2
                                              ? "잠금 시작 시간을 선택해주세요"
                                              : "잠금 종료 시간을 선택해주세요",
                                      style: const TextStyle(
                                          color: AppColor.textColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                    if (types == 2 && lastPages.last == 0)
                                      const Padding(
                                        padding: EdgeInsets.only(top: 3),
                                        child: Text(
                                          "블록 하나당 1시간입니다",
                                          style: TextStyle(
                                              color: AppColor.textColor2,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 24),
                                      child: GridView.count(
                                        crossAxisCount: 4,
                                        childAspectRatio: 1.8,
                                        shrinkWrap: true,
                                        children: List.generate(24, (index) {
                                          return GestureDetector(
                                            onTap: () {
                                              if (unableTime.contains(index)) {
                                                null;
                                              } else if (lastPages.last == 0) {
                                                setState(() {
                                                  if (checkedTime
                                                      .contains(index)) {
                                                    timeButton[index] = false;
                                                    checkedTime.remove(index);
                                                    if (checkedTime.isEmpty) {
                                                      isChecked2 = false;
                                                    }
                                                  } else if (checkedTime
                                                      .isEmpty) {
                                                    timeButton[index] = true;
                                                    checkedTime.add(index);
                                                    isChecked2 = true;
                                                  } else {
                                                    if (!checkTime(index)) {
                                                      snackBar(
                                                          title:
                                                              "연속된 시간을 선택해주세요",
                                                          content:
                                                              "연속된 시간만 신청 가능합니다");
                                                    } else {
                                                      timeButton[index] = true;
                                                    }
                                                  }
                                                });
                                              } else {
                                                setState(() {
                                                  if (checkedTime.isNotEmpty) {
                                                    timeButton[checkedTime
                                                        .first] = false;
                                                    checkedTime.clear();
                                                  }
                                                  timeButton[index] = true;
                                                  checkedTime.add(index);
                                                  isChecked2 = true;
                                                });
                                              }
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(2.0),
                                              decoration: BoxDecoration(
                                                color: unableTime
                                                        .contains(index)
                                                    ? AppColor.markColor
                                                        .withOpacity(0.7)
                                                    : timeButton[index]
                                                        ? AppColor.objectColor
                                                        : AppColor
                                                            .backgroundColor2,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  types == 2 &&
                                                          lastPages.last == 0
                                                      ? '$index:00'
                                                      : types == 2 &&
                                                              lastPages[lastPages
                                                                          .length -
                                                                      2] !=
                                                                  2
                                                          ? '$index:00'
                                                          : '${index + 1}:00',
                                                  style: TextStyle(
                                                    color: timeButton[index]
                                                        ? AppColor
                                                            .backgroundColor
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
                                    ),
                                    if (checkedTime.isNotEmpty)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Center(
                                          child: Text(
                                            types == 2 &&
                                                    lastPages.last == 0 &&
                                                    checkedTime.length == 1
                                                ? "선택한 시간: ${checkedTime[0]}시~${checkedTime[0] + 1}시 (총 1시간)"
                                                : types == 2 &&
                                                        lastPages.last == 0 &&
                                                        checkedTime.length != 1
                                                    ? "선택한 시간: ${checkedTime[0]}시~${checkedTime[checkedTime.length - 1] + 1}시 (총 ${checkedTime[checkedTime.length - 1] + 1 - checkedTime[0]}시간)"
                                                    : types == 2 &&
                                                            lastPages[lastPages
                                                                        .length -
                                                                    2] !=
                                                                2
                                                        ? "선택한 시간: ${checkedTime[0]}시"
                                                        : "선택한 시간: ${checkedTime[0] + 1}시",
                                            style: const TextStyle(
                                                color: AppColor.textColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                  ]),
                              child: Visibility(
                                visible: types != 6,
                                replacement: Column(
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
                                      padding:
                                          EdgeInsets.only(top: 32, bottom: 16),
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
                                                              BorderRadius
                                                                  .circular(10),
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
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    AppColor
                                                                        .subColor1,
                                                                shape:
                                                                    const CircleBorder(),
                                                                minimumSize:
                                                                    const Size(
                                                                        20,
                                                                        20)),
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
                                      padding:
                                          EdgeInsets.only(top: 32, bottom: 16),
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
                                child: Visibility(
                                  visible: types != 7,
                                  replacement: FutureBuilder(
                                      future: getLockList(setState),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<LockModel>>
                                              snapshot) {
                                        if (snapshot.hasData == false) {
                                          return const SizedBox();
                                        } else if (snapshot.hasError) {
                                          return const ErrorPage();
                                        } else if (snapshot.data!.isEmpty) {
                                          return const Center(
                                            child: Text(
                                              "잠금된 시간이 없습니다",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColor.textColor),
                                            ),
                                          );
                                        } else {
                                          return Column(
                                            children: [
                                              Column(
                                                  children: List.generate(
                                                      snapshot.data!.length,
                                                      (index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        if (checkedLock ==
                                                            index) {
                                                          checkedLock = -1;
                                                        } else {
                                                          checkedLock = index;
                                                        }
                                                      });
                                                    },
                                                    overlayColor:
                                                        MaterialStateProperty
                                                            .resolveWith<Color>(
                                                      (Set<MaterialState>
                                                          states) {
                                                        if (states.contains(
                                                            MaterialState
                                                                .pressed)) {
                                                          return Colors
                                                              .transparent;
                                                        }
                                                        return Colors
                                                            .transparent;
                                                      },
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              "잠금 시간",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: AppColor
                                                                      .textColor),
                                                            ),
                                                            Column(
                                                              children: [
                                                                Text(
                                                                  DateFormat(
                                                                          "yy년 MM월 dd일 H:00 부터",
                                                                          'ko_KR')
                                                                      .format(DateTime.parse(snapshot
                                                                          .data![
                                                                              index]
                                                                          .startDateTime)),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: AppColor
                                                                          .textColor),
                                                                ),
                                                                Text(
                                                                  DateFormat(
                                                                          "yy년 MM월 dd일 H:00 까지",
                                                                          'ko_KR')
                                                                      .format(DateTime.parse(snapshot
                                                                          .data![
                                                                              index]
                                                                          .endDateTime)),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: AppColor
                                                                          .textColor),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8,
                                                                  bottom: 8),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                "잠금 사유 (선택)",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: AppColor
                                                                        .textColor),
                                                              ),
                                                              Text(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .message,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: AppColor
                                                                        .textColor),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        if (checkedLock ==
                                                            index)
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    NextPageButton(
                                                                  text:
                                                                      const Text(
                                                                    "잠금 취소하기",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: AppColor
                                                                            .backgroundColor),
                                                                  ),
                                                                  buttonColor:
                                                                      AppColor
                                                                          .subColor3,
                                                                  onPressed:
                                                                      () async {
                                                                    setState(
                                                                        () {
                                                                      lock = snapshot
                                                                              .data![
                                                                          index];
                                                                    });
                                                                    await checkDeleteReservation(
                                                                        types:
                                                                            2,
                                                                        id: lock!
                                                                            .id);
                                                                    setState(
                                                                        () {
                                                                      lock =
                                                                          null;
                                                                    });
                                                                    getLockList(
                                                                        setState);
                                                                  },
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    NextPageButton(
                                                                  text:
                                                                      const Text(
                                                                    "잠금 수정하기",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: AppColor
                                                                            .backgroundColor),
                                                                  ),
                                                                  buttonColor: AppColor
                                                                      .objectColor
                                                                      .withOpacity(
                                                                          0.8),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      lock = snapshot
                                                                              .data![
                                                                          index];
                                                                      lockMessage
                                                                              .text =
                                                                          lock!
                                                                              .message;
                                                                      lockStartDate =
                                                                          DateTime.parse(
                                                                              lock!.startDateTime);
                                                                      lockEndDate =
                                                                          DateTime.parse(
                                                                              lock!.endDateTime);
                                                                      lockStartTime = int.parse(lock!
                                                                          .startDateTime
                                                                          .substring(
                                                                              11,
                                                                              13));
                                                                      lockEndTime = int.parse(lock!
                                                                          .endDateTime
                                                                          .substring(
                                                                              11,
                                                                              13));
                                                                      lastPages
                                                                          .add(
                                                                              7);
                                                                      types = 8;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 8,
                                                                  top: 8),
                                                          child: Divider(
                                                            height: 2,
                                                            color: AppColor
                                                                .backgroundColor2,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              })),
                                            ],
                                          );
                                        }
                                      }),
                                  child: Visibility(
                                    visible: types != 8,
                                    replacement: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "잠금 시간",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColor.textColor),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  updateStartDate =
                                                      lockStartDate;
                                                  updateEndDate = lockEndDate;
                                                  selectedDay = updateStartDate;
                                                  if (lastPages.isEmpty) {
                                                    lastPages.add(-1);
                                                  }
                                                  lastPages.add(8);
                                                  types = 1;
                                                });
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    DateFormat(
                                                            "yy년 MM월 dd일 $lockStartTime:00 부터",
                                                            'ko_KR')
                                                        .format(lockStartDate),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            AppColor.textColor),
                                                  ),
                                                  Text(
                                                    DateFormat(
                                                            "yy년 MM월 dd일 $lockEndTime:00 까지",
                                                            'ko_KR')
                                                        .format(lockEndDate),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            AppColor.textColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 32, bottom: 16),
                                          child: Text(
                                            "잠금 사유 (선택)",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Form(
                                            key: formKey4,
                                            child: OutlineTextForm(
                                              hintText: '회원들에게 간략하게 설명해주세요',
                                              controller: lockMessage,
                                              isFocused: isFocused4,
                                              fontSize: 16,
                                              maxLines: 7,
                                              onChanged: (value) {
                                                setState(() {
                                                  isFocused4 = value.isNotEmpty;
                                                });
                                              },
                                            )),
                                      ],
                                    ),
                                    child: FutureBuilder(
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
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Column(
                                                  children: List.generate(
                                                      snapshot.data!.length,
                                                      (index) {
                                                    if (types == 9) {
                                                      if (updateInvitees.any(
                                                          (element) =>
                                                              element["clubMemberId"] ==
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .id &&
                                                              element["clubMemberName"] ==
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .name)) {
                                                        isChecked.add(true);
                                                      } else {
                                                        isChecked.add(false);
                                                      }
                                                    } else if (types == 10) {
                                                      if (updateOwner[
                                                                  "clubMemberId"] ==
                                                              snapshot
                                                                  .data![index]
                                                                  .id &&
                                                          updateOwner[
                                                                  "clubMemberName"] ==
                                                              snapshot
                                                                  .data![index]
                                                                  .name) {
                                                        isChecked.add(true);
                                                      } else {
                                                        isChecked.add(false);
                                                      }
                                                    }

                                                    return Container(
                                                      width: SizeController
                                                          .to.screenWidth,
                                                      color: AppColor
                                                          .backgroundColor,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 12),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
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
                                                                              padding: const EdgeInsets.only(right: 12.0),
                                                                              child: ClipOval(
                                                                                child: snapshot.data![index].url != null
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
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              right: 12.0),
                                                                          child:
                                                                              Text(
                                                                            snapshot.data![index].name,
                                                                            style:
                                                                                const TextStyle(
                                                                              color: AppColor.textColor,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        if (!(snapshot.data![index].role ==
                                                                                "USER" &&
                                                                            snapshot.data![index].isConfirmed))
                                                                          Container(
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                6,
                                                                                2,
                                                                                6,
                                                                                2),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              shape: BoxShape.rectangle,
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              color: AppColor.subColor1, // 배경색 설정
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              (snapshot.data![index].role == "MANAGER") ? snapshot.data![index].clubAuthorityName ?? "" : "관리자",
                                                                              style: const TextStyle(
                                                                                color: AppColor.backgroundColor,
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 11,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Checkbox(
                                                                  value:
                                                                      isChecked[
                                                                          index],
                                                                  onChanged:
                                                                      (value) {
                                                                    if (types ==
                                                                        9) {
                                                                      setState(
                                                                          () {
                                                                        isChecked[index] =
                                                                            value!;
                                                                        if (value ==
                                                                            true) {
                                                                          updateInvitees
                                                                              .add({
                                                                            "clubMemberId":
                                                                                snapshot.data![index].id,
                                                                            "clubMemberName":
                                                                                snapshot.data![index].name
                                                                          });
                                                                        } else {
                                                                          updateInvitees.removeWhere((element) =>
                                                                              element["clubMemberId"] == snapshot.data![index].id &&
                                                                              element["clubMemberName"] == snapshot.data![index].name);
                                                                        }
                                                                      });
                                                                    } else if (types ==
                                                                        10) {
                                                                      setState(
                                                                          () {
                                                                        for (int i =
                                                                                0;
                                                                            i < isChecked.length;
                                                                            i++) {
                                                                          isChecked[i] =
                                                                              false;
                                                                        }
                                                                        isChecked[index] =
                                                                            value!;
                                                                        updateOwner =
                                                                            {
                                                                          "clubMemberId": snapshot
                                                                              .data![index]
                                                                              .id,
                                                                          "clubMemberName": snapshot
                                                                              .data![index]
                                                                              .name
                                                                        };
                                                                      });
                                                                    }
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
                                  ),
                                ),
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
                        buttonColor: isChecked1
                            ? AppColor.objectColor
                            : AppColor.subColor3,
                        onPressed: () async {
                          if (checkedTime.isNotEmpty) {
                            try {
                              String startDateTime =
                                  (0 <= startTime && startTime <= 9)
                                      ? DateFormat(
                                              "yyyy-MM-dd 0$startTime:00:00",
                                              'ko_KR')
                                          .format(reservationTime)
                                      : DateFormat(
                                              "yyyy-MM-dd $startTime:00:00",
                                              'ko_KR')
                                          .format(reservationTime);
                              String endDateTime = (0 <= endTime &&
                                      endTime <= 9)
                                  ? DateFormat(
                                          "yyyy-MM-dd 0$endTime:00:00", 'ko_KR')
                                      .format(reservationTime)
                                  : DateFormat(
                                          "yyyy-MM-dd $endTime:00:00", 'ko_KR')
                                      .format(reservationTime);
                              List<int> clubMemberIds = invitees
                                  .map((invitee) =>
                                      invitee["clubMemberId"] as int)
                                  .toList();
                              if (types == 0) {
                                await ReservationApiService.postReservation(
                                    reservationOwnerId: owner['clubMemberId'],
                                    resourceId: selectedValue!.id,
                                    title: title.text,
                                    color: AppColor.getColorHex(selectedColor),
                                    usage: usage.text,
                                    sharing: (open == Open.yes) ? true : false,
                                    startDateTime: startDateTime,
                                    endDateTime: endDateTime,
                                    reservationInvitees: clubMemberIds);
                              } else {
                                await ReservationApiService.putReservation(
                                    reservationId: reservation!.reservationId,
                                    resourceId: selectedValue!.id,
                                    title: title.text,
                                    color: AppColor.getColorHex(selectedColor),
                                    usage: usage.text,
                                    sharing: (open == Open.yes) ? true : false,
                                    startDateTime: startDateTime,
                                    endDateTime: endDateTime,
                                    reservationInvitees: clubMemberIds);
                                await ReservationApiService
                                    .patchReservationOwner(
                                        reservationId:
                                            reservation.reservationId,
                                        reservationOwnerId:
                                            owner['clubMemberId']);
                              }
                              getReservations();
                              Get.back();
                            } catch (e) {
                              print(e.toString());
                              if (types == 0) {
                                snackBar(
                                    title: "예약 신청에 문제가 발생하였습니다",
                                    content: "관리자에게 문의해주세요");
                              } else {
                                snackBar(
                                    title: "예약 수정에 문제가 발생하였습니다",
                                    content: "관리자에게 문의해주세요");
                              }
                            }
                          }
                        },
                      ),
                      child: Visibility(
                        visible: types != 3,
                        replacement: Visibility(
                          visible: ((MemberController.to.clubMember().role ==
                                      "ADMIN" ||
                                  (MemberController.to
                                              .clubMember()
                                              .clubAuthorityTypes !=
                                          null &&
                                      MemberController.to
                                          .clubMember()
                                          .clubAuthorityTypes!
                                          .contains("SCHEDULE_ALL"))) &&
                              reservation?.status == "REQUEST"),
                          replacement: Column(
                            children: [
                              if ((reservation?.clubMemberId ==
                                      MemberController.to.clubMember().id) &&
                                  reservation != null &&
                                  DateTime.parse(reservation.endDateTime)
                                      .isBefore(now) &&
                                  !reservation.returned)
                                NextPageButton(
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
                                      lastPages.add(3);
                                      types = 6;
                                    });
                                  },
                                ),
                              if (!((reservation != null &&
                                          DateTime.parse(
                                                  reservation.endDateTime)
                                              .isBefore(now) ||
                                      reservation?.clubMemberId !=
                                          MemberController.to
                                              .clubMember()
                                              .id) &&
                                  !(MemberController.to.clubMember().role ==
                                          "ADMIN" ||
                                      (MemberController.to
                                                  .clubMember()
                                                  .clubAuthorityTypes !=
                                              null &&
                                          MemberController.to
                                              .clubMember()
                                              .clubAuthorityTypes!
                                              .contains("SCHEDULE_ALL")))))
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16, left: 24.0, right: 24.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Visibility(
                                          visible: reservation?.clubMemberId ==
                                                  MemberController.to
                                                      .clubMember()
                                                      .id &&
                                              reservation != null &&
                                              DateTime.parse(
                                                      reservation.endDateTime)
                                                  .isAfter(now),
                                          replacement: NextPageButton(
                                            text: const Text(
                                              "예약 삭제하기",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      AppColor.backgroundColor),
                                            ),
                                            buttonColor: AppColor.markColor,
                                            onPressed: () async {
                                              await checkDeleteReservation(
                                                  id: reservation!
                                                      .reservationId,
                                                  types: 0);
                                            },
                                          ),
                                          child: NextPageButton(
                                            text: const Text(
                                              "예약 취소하기",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      AppColor.backgroundColor),
                                            ),
                                            buttonColor: AppColor.subColor3,
                                            onPressed: () async {
                                              await checkDeleteReservation(
                                                  id: reservation!
                                                      .reservationId,
                                                  types: 1);
                                            },
                                          ),
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
                                                color:
                                                    AppColor.backgroundColor),
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
                            ],
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 24.0, right: 24.0),
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
                                      rejectReservation(
                                          id: reservation!.reservationId);
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
                                        await ReservationApiService
                                            .patchReservation(
                                                reservationIds: [
                                              reservation?.reservationId
                                            ],
                                                rejectMessages: [],
                                                isConfirmed: true);
                                        getReservations();
                                        Get.back();
                                      } catch (e) {
                                        print(e.toString());
                                        snackBar(
                                            title: "예약을 승인하지 못했습니다",
                                            content: "잠시 후 다시 시도해 주세요");
                                      }
                                    },
                                  ),
                                ),
                              ],
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
                                        reservationId:
                                            reservation!.reservationId,
                                        returnImage: selectedImages,
                                        returnMessage: message.text);
                                Get.back();
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                          ),
                          child: Visibility(
                            visible:
                                !(types == 7 || (types == 8 && lock == null)),
                            replacement: NextPageButton(
                              text: const Text(
                                "잠금 시간 추가하기",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.backgroundColor),
                              ),
                              buttonColor: AppColor.objectColor,
                              onPressed: () async {
                                if (types == 7) {
                                  setState(() {
                                    selectedDay = now;
                                    updateStartDate = now;
                                    updateEndDate = now;
                                    updateStartTime = -1;
                                    lastPages.add(7);
                                    types = 1;
                                  });
                                } else {
                                  try {
                                    String startDateTime = (0 <=
                                                lockStartTime &&
                                            lockStartTime <= 9)
                                        ? DateFormat(
                                                "yyyy-MM-dd 0$lockStartTime:00:00",
                                                'ko_KR')
                                            .format(lockStartDate)
                                        : DateFormat(
                                                "yyyy-MM-dd $lockStartTime:00:00",
                                                'ko_KR')
                                            .format(lockStartDate);
                                    String endDateTime = (0 <= lockEndTime &&
                                            lockEndTime <= 9)
                                        ? DateFormat(
                                                "yyyy-MM-dd 0$lockEndTime:00:00",
                                                'ko_KR')
                                            .format(lockEndDate)
                                        : DateFormat(
                                                "yyyy-MM-dd $lockEndTime:00:00",
                                                'ko_KR')
                                            .format(lockEndDate);
                                    LockModel temp =
                                        await LockApiService.postLock(
                                            resourceId: selectedValue!.id,
                                            startDateTime: startDateTime,
                                            endDateTime: endDateTime,
                                            message: lockMessage.text);
                                    getLockList(setState);
                                    getReservations();
                                    setState(() {
                                      lockStartDate = now;
                                      lockEndDate = now;
                                      lockStartTime = -1;
                                      lockEndTime = -1;
                                      lockMessage.clear();
                                      types = 7;
                                    });
                                  } catch (e) {
                                    print(e.toString());
                                    snackBar(
                                        title: "잠금 시간 추가가 불가능합니다",
                                        content: "시간을 조정해주세요");
                                  }
                                }
                              },
                            ),
                            child: Visibility(
                              visible: !(types == 8 && lock != null),
                              replacement: NextPageButton(
                                text: const Text(
                                  "잠금 수정하기",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.backgroundColor),
                                ),
                                buttonColor: AppColor.objectColor,
                                onPressed: () async {
                                  try {
                                    String startDateTime = '';
                                    String endDateTime = '';
                                    if (types == 8 &&
                                        lock != null &&
                                        lastPages.last != -1) {
                                      startDateTime = lock!.startDateTime;
                                      endDateTime = lock!.endDateTime;
                                    } else {
                                      startDateTime = (0 <= lockStartTime &&
                                              lockStartTime <= 9)
                                          ? DateFormat(
                                                  "yyyy-MM-dd 0$lockStartTime:00:00",
                                                  'ko_KR')
                                              .format(lockStartDate)
                                          : DateFormat(
                                                  "yyyy-MM-dd $lockStartTime:00:00",
                                                  'ko_KR')
                                              .format(lockStartDate);
                                      endDateTime = (0 <= lockEndTime &&
                                              lockEndTime <= 9)
                                          ? DateFormat(
                                                  "yyyy-MM-dd 0$lockEndTime:00:00",
                                                  'ko_KR')
                                              .format(lockEndDate)
                                          : DateFormat(
                                                  "yyyy-MM-dd $lockEndTime:00:00",
                                                  'ko_KR')
                                              .format(lockEndDate);
                                    }
                                    LockModel temp =
                                        await LockApiService.putLock(
                                            resourceId: selectedValue!.id,
                                            startDateTime: startDateTime,
                                            endDateTime: endDateTime,
                                            message: lockMessage.text,
                                            lockId: lock!.id);
                                    getLockList(setState);
                                    getReservations();
                                    setState(() {
                                      lock = null;
                                      lockStartDate = now;
                                      lockEndDate = now;
                                      selectedDay = now;
                                      lockStartTime = -1;
                                      lockEndTime = -1;
                                      lastPages.clear();
                                      lockMessage.clear();
                                      types = 7;
                                    });
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
                                buttonColor:
                                    types == 1 || types == 9 || types == 10
                                        ? AppColor.objectColor
                                        : isChecked2
                                            ? AppColor.objectColor
                                            : AppColor.subColor3,
                                onPressed: () {
                                  if (types == 1) {
                                    if (lastPages.last == 0) {
                                      setState(() {
                                        reservationTime = selectedDay;
                                        types = lastPages.removeLast();
                                      });
                                    } else if (lastPages.last == 7 ||
                                        lastPages.last == 8 ||
                                        lastPages.last == 2) {
                                      setState(() {
                                        if (lastPages.last == 7 ||
                                            lastPages.last == 8) {
                                          updateStartDate = selectedDay;
                                        } else {
                                          updateEndDate = selectedDay;
                                        }
                                        lastPages.add(1);
                                        types = 2;
                                      });
                                    }
                                  } else if (types == 2 &&
                                      checkedTime.isNotEmpty) {
                                    if (lastPages.last == 0) {
                                      setState(() {
                                        isChecked1 = true;
                                        startTime = checkedTime[0];
                                        endTime = checkedTime[0] + 1;
                                        if (checkedTime.length > 1) {
                                          endTime = checkedTime[
                                                  checkedTime.length - 1] +
                                              1;
                                        }
                                        types = lastPages.removeLast();
                                      });
                                    } else if (lastPages[
                                            lastPages.length - 2] !=
                                        2) {
                                      setState(() {
                                        updateStartTime = checkedTime[0];
                                        selectedDay =
                                            lockEndDate != updateStartDate
                                                ? updateStartDate
                                                : lockEndDate;
                                        focusedDay =
                                            lockEndDate != updateStartDate
                                                ? updateStartDate
                                                : lockEndDate;
                                        lastPages.add(2);
                                        types = 1;
                                      });
                                    } else {
                                      setState(() {
                                        lockStartDate = updateStartDate;
                                        lockEndDate = updateEndDate;
                                        lockStartTime = updateStartTime;
                                        lockEndTime = checkedTime[0] + 1;
                                        updateStartDate = now;
                                        updateEndDate = now;
                                        updateStartTime = -1;
                                        if (lastPages[1] == 8 &&
                                            lastPages.first != -1) {
                                          lastPages.clear();
                                          lastPages.add(7);
                                          lastPages.add(-1);
                                        } else {
                                          lastPages.clear();
                                        }
                                        types = 8;
                                      });
                                    }
                                  } else if (types == 5) {
                                    setState(() {
                                      selectedDate = selectedDay;
                                      standardDay = selectedDate;
                                    });
                                    getReservations();
                                    weekViewStateKey.currentState
                                        ?.jumpToWeek(selectedDate);
                                    Get.back();
                                  } else if (types == 9) {
                                    setState(() {
                                      invitees.clear();
                                      invitees.addAll(updateInvitees);
                                      updateInvitees.clear();
                                      types = lastPages.removeLast();
                                    });
                                  } else if (types == 10) {
                                    setState(() {
                                      owner = updateOwner;
                                      types = lastPages.removeLast();
                                    });
                                  } else {
                                    snackBar(
                                        title: "시간을 선택하지 않았습니다",
                                        content: "최소 한시간 이상 선택해주세요");
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
  /// types == 2 : 잠금 삭제
  Future<void> checkDeleteReservation(
      {required int types, required int id}) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Center(
            child: Text(
              types == 0
                  ? "예약 삭제"
                  : types == 1
                      ? "예약 취소"
                      : "잠금 삭제",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              types == 0
                  ? "한번 삭제한 예약은"
                  : types == 1
                      ? "한번 취소한 예약은"
                      : "한번 취소한 잠금은",
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
                        getReservations();
                        Get.back(result: true);
                        Get.back();
                      } else if (types == 1) {
                        await ReservationApiService.cancelReservation(
                            reservationId: id);
                        getReservations();
                        Get.back(result: true);
                        Get.back();
                      } else {
                        await LockApiService.deleteLock(lockId: id);
                        getReservations();
                        Get.back(result: true);
                      }
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

  Future<void> rejectReservation({required int id}) async {
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
                          reservationIds: [id],
                          rejectMessages: [rejectMessage.text],
                          isConfirmed: false);
                      getReservations();
                      Get.back();
                      Get.back();
                    } catch (e) {
                      print(e.toString());
                      snackBar(
                          title: "예약을 거절하지 못했습니다", content: "잠시 후 다시 시도해 주세요");
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
