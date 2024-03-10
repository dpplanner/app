import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/controllers/size.dart';
import 'package:dplanner/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:table_calendar/table_calendar.dart' as calendar;

import '../controllers/club.dart';
import '../controllers/item.dart';
import '../models/resource_model.dart';
import '../services/resource_api_service.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/nextpage_button.dart';
import 'error_page.dart';

DateTime get _now => DateTime.now();

enum Open { yes, no }

class ClubTimetablePage extends StatefulWidget {
  const ClubTimetablePage({super.key});

  @override
  State<ClubTimetablePage> createState() => _ClubTimetablePageState();
}

class _ClubTimetablePageState extends State<ClubTimetablePage> {
  final GlobalKey<WeekViewState> weekViewStateKey = GlobalKey<WeekViewState>();
  EventController eventController = EventController();

  final itemController = Get.put((ItemController()));
  String selectedValue = "";

  Open _open = Open.yes;

  Future<List<ResourceModel>> getResources() async {
    try {
      List<List<ResourceModel>> resources =
          await ResourceApiService.getResources();
      ClubController.to.resources.value = resources[0] + resources[1];
      selectedValue = ClubController.to.resources[0].name;
      return resources[0] + resources[1];
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
        body: Visibility(
          visible: ClubController.to.resources().isEmpty,
          replacement: Stack(
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
                      child: Row(
                        children: [
                          SizedBox(width: SizeController.to.screenWidth * 0.12),
                          Expanded(
                            child: WeekPageHeader(
                              headerStringBuilder: (DateTime dateTime,
                                  {DateTime? secondaryDate}) {
                                return DateFormat("MM월").format(dateTime);
                              },
                              headerStyle: HeaderStyle(
                                  decoration: BoxDecoration(
                                    color: AppColor.subColor4,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  headerTextStyle: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                  rightIconVisible: false,
                                  leftIcon: InkWell(
                                      onTap: () {
                                        weekViewStateKey.currentState
                                            ?.jumpToWeek(DateTime.now());
                                      },
                                      child: const Icon(
                                          SFSymbols.calendar_today,
                                          color: AppColor.textColor)),
                                  titleAlign: TextAlign.left),
                              startDate: startDate,
                              endDate: endDate,
                              onTitleTapped: () async {
                                DateTime selectedDate = startDate;
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height:
                                          SizeController.to.screenHeight * 0.4,
                                      decoration: const BoxDecoration(
                                        color: AppColor.backgroundColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, bottom: 8.0),
                                            child: SvgPicture.asset(
                                              'assets/images/extra/showmodal_scrollcontrolbar.svg',
                                            ),
                                          ),
                                          const Text(
                                            "날짜",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 18),
                                          ),
                                          Expanded(
                                            child: CupertinoDatePicker(
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                              initialDateTime: startDate,
                                              minimumYear: 2020,
                                              maximumYear: 2029,
                                              onDateTimeChanged:
                                                  (DateTime date) {
                                                setState(() {
                                                  selectedDate = date;
                                                });
                                              },
                                            ),
                                          ),
                                          NextPageButton(
                                            text: const Text(
                                              "날짜 변경하기",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      AppColor.backgroundColor),
                                            ),
                                            buttonColor: AppColor.objectColor,
                                            onPressed: () {
                                              weekViewStateKey.currentState
                                                  ?.jumpToWeek(selectedDate);
                                              Get.back();
                                            },
                                          ),
                                          SizedBox(
                                            height:
                                                SizeController.to.screenHeight *
                                                    0.03,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),

                          ///DropdownButton

                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: SizeController.to.screenWidth * 0.05),
                              child: FutureBuilder(
                                  future: getResources(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData == false) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return const ErrorPage();
                                    } else if (snapshot.data.length == 0) {
                                      return const Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "공유 물품 없음",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: AppColor.textColor2,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          items: ClubController.to.resources
                                              .map((ResourceModel resource) =>
                                                  DropdownMenuItem<String>(
                                                    value: resource.name,
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
                                          onChanged: (String? value) {
                                            setState(() {
                                              selectedValue = value!;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: 50,
                                            width:
                                                SizeController.to.screenWidth *
                                                    0.3,
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
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
                                            offset: const Offset(0, 45),
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
                                            padding: EdgeInsets.only(
                                                left: 14, right: 14),
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
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
                            (date.isAtSameMomentAs(DateTime.now().withoutTime))
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
                            (date.isAtSameMomentAs(DateTime.now().withoutTime))
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
                            color: DateTime.now().hour == date.hour
                                ? AppColor.subColor1
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            date.hour < 10 ? "0${date.hour}" : "${date.hour}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: DateTime.now().hour == date.hour
                                  ? AppColor.textColor
                                  : AppColor.textColor2,
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
                      height: 0.7, color: AppColor.backgroundColor, offset: 0),
                  liveTimeIndicatorSettings: const HourIndicatorSettings(
                      color: AppColor.subColor1, height: 0, offset: 5),
                  eventTileBuilder: (date, events, boundry, start, end) {
                    if (events.isNotEmpty) {
                      return RoundedEventTile(
                        borderRadius: BorderRadius.circular(0.0),
                        title: events[0].title,
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
                  pageTransitionDuration: const Duration(milliseconds: 300),
                  pageTransitionCurve: Curves.linear,
                  showLiveTimeLineInAllDays: false,
                  backgroundColor: Colors.transparent,
                  minuteSlotSize: MinuteSlotSize.minutes60,
                  width: SizeController.to.screenWidth * 0.92,
                  minDay: DateTime(2020),
                  maxDay: DateTime(2030),
                  initialDay: DateTime.now(),
                  startDay: WeekDays.monday,
                  heightPerMinute: SizeController.to.screenHeight * 0.0012,
                  eventArranger: const SideEventArranger(),
                  onEventTap: (events, date) => {},
                  onDateLongPress: (date) => {},
                ),
              ),
            ],
          ),
          child: RefreshIndicator(
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
                      if (MemberController.to.clubMember().role == "ADMIN")
                        Column(
                          children: [
                            const Text(
                              "공유 물품을 추가할까요?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed('/resource_list');
                              },
                              style: ButtonStyle(
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
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
          ),
        ),
        floatingActionButton: (ClubController.to.resources().isEmpty)
            ? null
            : ElevatedButton(
                onPressed: () {
                  addReservation(types: 0);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.objectColor,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(15),
                ),
                child: const Icon(
                  SFSymbols.plus,
                  color: AppColor.backgroundColor,
                ),
              ),
        bottomNavigationBar: const BottomBar());
  }

  void addReservation({required int types}) async {
    DateTime reservationTime = _now;
    DateTime focusedDay = DateTime.now();
    DateTime selectedDay = DateTime.now();

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
                        (types == 0)
                            ? "예약하기"
                            : (types == 1)
                                ? "예약 날짜"
                                : "예약 시간",
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
                        visible: types != 0,
                        replacement: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "신청 품목",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                Text(
                                  selectedValue,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeController.to.screenHeight * 0.04,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "신청 날짜",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        types = 1;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(5),
                                    child: Text(
                                        DateFormat("yyyy. MM. dd. E요일", 'ko_KR')
                                            .format(reservationTime),
                                        style: const TextStyle(
                                            color: AppColor.textColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16))),
                              ],
                            ),
                            SizedBox(
                              height: SizeController.to.screenHeight * 0.04,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "신청 시간",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                Text(
                                  "14:00 ~ 16:00(2시간)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeController.to.screenHeight * 0.04,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "사용 용도(선택)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                Text(
                                  "사용 용도를 입력해주세요",
                                  style: TextStyle(
                                      color: AppColor.textColor2,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeController.to.screenHeight * 0.04,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "함께 사용하는 사람(선택)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                Text(
                                  "선택하기",
                                  style: TextStyle(
                                      color: AppColor.textColor2,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeController.to.screenHeight * 0.04,
                            ),
                            const Text(
                              "신청하신 시간에\n다른 사람이 함께 사용할 수 있나요?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            SizedBox(
                              height: SizeController.to.screenHeight * 0.04,
                              child: RadioListTile(
                                title: const Text(
                                  "누구나 함께 사용 가능합니다",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                value: Open.yes,
                                groupValue: _open,
                                onChanged: (Open? value) {
                                  setState(() {
                                    _open = value!;
                                  });
                                },
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: -5.0),
                              ),
                            ),
                            SizedBox(
                              height: SizeController.to.screenHeight * 0.04,
                              child: RadioListTile(
                                title: const Text(
                                  "허가받은 사람 외에는 불가능합니다",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                value: Open.no,
                                groupValue: _open,
                                onChanged: (Open? value) {
                                  setState(() {
                                    _open = value!;
                                  });
                                },
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: -30.0, horizontal: -10),
                              ),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "예약할 날짜를 선택해주세요",
                                style: TextStyle(
                                    color: AppColor.textColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                            calendar.TableCalendar(
                              rowHeight: SizeController.to.screenHeight * 0.045,
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
                                  leftChevronIcon: Icon(SFSymbols.chevron_left,
                                      color: AppColor.textColor),
                                  rightChevronIcon: Icon(
                                      SFSymbols.chevron_right,
                                      color: AppColor.textColor),
                                  titleTextStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.textColor),
                                  formatButtonTextStyle: TextStyle(
                                      fontSize: 15, color: AppColor.textColor),
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
                                    focusedDay = DateTime(
                                        selectedDay.year, selectedDay.month, 1);
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
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 40.0),
                  child: Visibility(
                    visible: types != 0,
                    replacement: NextPageButton(
                      text: const Text(
                        "예약 신청하기",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColor.backgroundColor),
                      ),
                      buttonColor: AppColor.objectColor,
                      onPressed: () {
                        Get.back();
                        eventController.addAll(_events);
                        Future.delayed(const Duration(milliseconds: 200), () {
                          _reservationConfirmDialog(context);
                        });
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
                      buttonColor: AppColor.objectColor,
                      onPressed: () {
                        setState(() {
                          types = 0;
                        });
                      },
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

  void _reservationConfirmDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.backgroundColor,
          title: const Center(
            child: Text(
              '신청완료',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '정상적으로 신청이 완료되었습니다.',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              Text(
                '관리자가 확인 후, 신청을 승인해드립니다.',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              Text(
                '승인이 되면 푸시 알림을 보내드릴까요?',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ],
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: AppColor.objectColor,
                      minimumSize: Size(
                          SizeController.to.screenWidth * 0.5,
                          SizeController.to.screenHeight *
                              0.05), //width, height
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      '네, 보내주세요',
                      style: TextStyle(
                          color: AppColor.backgroundColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: SizeController.to.screenHeight * 0.01,
                  ),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      borderRadius: BorderRadius.circular(5),
                      child: const Text('아니오, 괜찮습니다.',
                          style: TextStyle(
                              color: AppColor.textColor2,
                              fontWeight: FontWeight.w400,
                              fontSize: 14))),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

List<CalendarEventData<Object?>> _events = [
  CalendarEventData(
      date: _now.add(const Duration(days: 1)),
      title: "정찬영\nDP22",
      startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
      endTime: DateTime(_now.year, _now.month, _now.day, 22),
      color: AppColor.subColor3),
  CalendarEventData(
      date: _now,
      startTime: DateTime(_now.year, _now.month, _now.day),
      endTime: DateTime(_now.year, _now.month, _now.day, 23, 59),
      endDate: _now,
      title: '',
      color: AppColor.subColor4),
  CalendarEventData(
      date: _now.add(const Duration(days: 1)),
      startTime: DateTime(_now.year, _now.month, _now.day, 0),
      endTime: DateTime(_now.year, _now.month, _now.day, 2),
      title: "강지인\nDP23",
      description: "개인연습",
      color: AppColor.subColor3),
  CalendarEventData(
      date: _now.add(const Duration(days: 1)),
      startTime: DateTime(_now.year, _now.month, _now.day, 14),
      endTime: DateTime(_now.year, _now.month, _now.day, 17),
      title: "집행회의",
      color: AppColor.subColor1)
];
