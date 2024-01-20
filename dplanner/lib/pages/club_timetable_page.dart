import 'package:dplanner/controllers/size.dart';
import 'package:dplanner/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

DateTime get _now => DateTime.now();

enum ViewSelect {
  room1,
  room2,
  room3;

  String get title => const <ViewSelect, String>{
        ViewSelect.room1: '동아리방',
        ViewSelect.room2: '3층',
        ViewSelect.room3: '6층',
      }[this]!;
}

class ClubTimetablePage extends StatefulWidget {
  const ClubTimetablePage({super.key});

  @override
  State<ClubTimetablePage> createState() => _ClubTimetablePageState();
}

class _ClubTimetablePageState extends State<ClubTimetablePage> {
  int selectNum = 0;
  ViewSelect _viewSelect = ViewSelect.room1;
  final GlobalKey<WeekViewState> weekViewStateKey = GlobalKey<WeekViewState>();
  EventController eventController = EventController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColor.backgroundColor,
          title: const Text(
            "Dance P.O.zz",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: SizeController.to.screenHeight * 0.08,
                color: AppColor.backgroundColor,
              ),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: SizeController.to.screenWidth * 0.11,
                      color: AppColor.backgroundColor,
                    ),
                    Expanded(
                      child: Container(
                        color: AppColor.backgroundColor2,
                      ),
                    ),
                    Container(
                      width: SizeController.to.screenWidth * 0.04,
                      color: AppColor.backgroundColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Center(
            child: WeekView(
              key: weekViewStateKey,
              controller: eventController,
              weekPageHeaderBuilder: (DateTime startDate, DateTime endDate) {
                return WeekPageHeader(
                  headerStringBuilder: (DateTime dateTime,
                      {DateTime? secondaryDate}) {
                    return DateFormat("yy년 MM월").format(dateTime);
                  },
                  headerStyle: HeaderStyle(
                      decoration: BoxDecoration(
                        color: AppColor.subColor4,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      headerTextStyle: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18),
                      headerMargin: EdgeInsets.only(
                          left: SizeController.to.screenWidth * 0.05,
                          right: SizeController.to.screenWidth * 0.5),
                      rightIconVisible: false,
                      leftIcon: InkWell(
                          onTap: () {
                            weekViewStateKey.currentState
                                ?.jumpToWeek(DateTime.now());
                          },
                          child: const Icon(SFSymbols.calendar_today,
                              color: AppColor.textColor)),
                      titleAlign: TextAlign.center),
                  startDate: startDate,
                  endDate: endDate,
                  onTitleTapped: () async {
                    DateTime selectedDate = startDate;
                    await showCupertinoDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: AppColor.backgroundColor,
                            height: SizeController.to.screenHeight * 0.4,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20),
                                            )),
                                        TextButton(
                                          onPressed: () {
                                            weekViewStateKey.currentState
                                                ?.jumpToWeek(selectedDate);
                                            Get.back();
                                          },
                                          child: const Text(
                                            "done",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.date,
                                    initialDateTime: startDate,
                                    minimumYear: 2020,
                                    maximumYear: 2030,
                                    onDateTimeChanged: (DateTime date) {
                                      setState(() {
                                        selectedDate = date;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              weekDayBuilder: (DateTime date) {
                return Container(
                  color: AppColor.backgroundColor,
                  alignment: Alignment.center,
                  child: (date.day == DateTime.now().day)
                      ? const Text(
                          '오늘',
                          style: TextStyle(
                              color: AppColor.markColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        )
                      : Text(
                          DateFormat.d().format(date),
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                );
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
                  height: 0, color: Colors.transparent, offset: 0),
              liveTimeIndicatorSettings: const HourIndicatorSettings(
                  color: AppColor.subColor1, height: 0, offset: 0),
              eventTileBuilder: (date, events, boundry, start, end) {
                if (events.isNotEmpty) {
                  return RoundedEventTile(
                    borderRadius: BorderRadius.circular(0.0),
                    title: events[0].title,
                    titleStyle: events[0].titleStyle ??
                        const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColor.backgroundColor,
                          fontSize: 12,
                        ),
                    description: events[0].description,
                    descriptionStyle: events[0].descriptionStyle ??
                        const TextStyle(
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
              startDay: WeekDays.sunday,
              heightPerMinute: SizeController.to.screenHeight * 0.0012,
              eventArranger: const SideEventArranger(),
              onEventTap: (events, date) => print(events),
              onDateLongPress: (date) => print(date),
            ),
          ),

          ///DropdownButton
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding:
                  EdgeInsets.only(right: SizeController.to.screenWidth * 0.05),
              child: SizedBox(
                width: SizeController.to.screenWidth * 0.25,
                child: DropdownButton<ViewSelect>(
                    icon: const Icon(
                      SFSymbols.chevron_down,
                    ),
                    iconSize: 15,
                    iconEnabledColor: AppColor.textColor,
                    dropdownColor: AppColor.backgroundColor,
                    value: _viewSelect,
                    borderRadius: BorderRadius.circular(10),
                    isExpanded: true,
                    underline: Container(),
                    onChanged: (ViewSelect? newValue) {
                      setState(() {
                        _viewSelect = newValue!;
                      });
                    },
                    items: ViewSelect.values.map((ViewSelect status) {
                      return DropdownMenuItem<ViewSelect>(
                        value: status,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            status.title,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColor.textColor),
                          ),
                        ),
                      );
                    }).toList()),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          eventController.addAll(_events);
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
