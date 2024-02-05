import 'package:dplanner/controllers/size.dart';
import 'package:dplanner/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../controllers/item.dart';
import '../widgets/nextpage_button.dart';

DateTime get _now => DateTime.now();

enum Open { Yes, No }

class ClubTimetablePage extends StatefulWidget {
  const ClubTimetablePage({super.key});

  @override
  State<ClubTimetablePage> createState() => _ClubTimetablePageState();
}

class _ClubTimetablePageState extends State<ClubTimetablePage> {
  final GlobalKey<WeekViewState> weekViewStateKey = GlobalKey<WeekViewState>();
  EventController eventController = EventController();

  final itemController = Get.put((ItemController()));
  late String selectedValue = ItemController.to.items[0];

  Open _open = Open.Yes;

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
                    return DateFormat("MM월").format(dateTime);
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
                          right: SizeController.to.screenWidth * 0.63),
                      rightIconVisible: false,
                      leftIcon: InkWell(
                          onTap: () {
                            weekViewStateKey.currentState
                                ?.jumpToWeek(DateTime.now());
                          },
                          child: const Icon(SFSymbols.calendar_today,
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
                          height: SizeController.to.screenHeight * 0.4,
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
                                child: Image.asset(
                                  'assets/images/showmodal_scrollcontrolbar.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const Text(
                                "날짜",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 18),
                              ),
                              Expanded(
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.date,
                                  initialDateTime: startDate,
                                  minimumYear: 2020,
                                  maximumYear: 2029,
                                  onDateTimeChanged: (DateTime date) {
                                    setState(() {
                                      selectedDate = date;
                                    });
                                  },
                                ),
                              ),
                              NextPageButton(
                                name: '날짜 변경하기',
                                buttonColor: AppColor.objectColor,
                                onPressed: () {
                                  weekViewStateKey.currentState
                                      ?.jumpToWeek(selectedDate);
                                  Get.back();
                                },
                              ),
                              SizedBox(
                                height: SizeController.to.screenHeight * 0.03,
                              ),
                            ],
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
                                    fontWeight: FontWeight.w400, fontSize: 12),
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
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  items: ItemController.to.items
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                item,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.textColor),
                                overflow: TextOverflow.ellipsis,
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
                    width: SizeController.to.screenWidth * 0.3,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColor.backgroundColor,
                    ),
                  ),
                  iconStyleData: const IconStyleData(
                      icon: Icon(
                        SFSymbols.chevron_down,
                      ),
                      iconSize: 15,
                      iconEnabledColor: AppColor.textColor),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    width: SizeController.to.screenWidth * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: AppColor.backgroundColor,
                    ),
                    offset: const Offset(0, 45),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all<double>(6),
                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          _reservationBottomSheet(context);
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

  void _reservationBottomSheet(BuildContext context) async {
    DateTime resetvationTime = _now;
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: SizeController.to.screenHeight * 0.7,
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
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Image.asset(
                        'assets/images/showmodal_scrollcontrolbar.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      height: SizeController.to.screenHeight * 0.005,
                    ),
                    const Text(
                      "예약하기",
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "신청 품목",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                              Text(
                                selectedValue,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
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
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                              InkWell(
                                  onTap: () async {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height:
                                              SizeController.to.screenHeight *
                                                  0.4,
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
                                                child: Image.asset(
                                                  'assets/images/showmodal_scrollcontrolbar.png',
                                                  fit: BoxFit.fill,
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
                                                  mode: CupertinoDatePickerMode
                                                      .date,
                                                  initialDateTime:
                                                      resetvationTime,
                                                  minimumYear: _now.year,
                                                  maximumYear: _now.year + 10,
                                                  onDateTimeChanged:
                                                      (DateTime date) {
                                                    setState(() {
                                                      resetvationTime = date;
                                                    });
                                                  },
                                                ),
                                              ),
                                              NextPageButton(
                                                name: '날짜 변경하기',
                                                buttonColor:
                                                    AppColor.objectColor,
                                                onPressed: () {
                                                  Get.back();
                                                },
                                              ),
                                              SizedBox(
                                                height: SizeController
                                                        .to.screenHeight *
                                                    0.03,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(5),
                                  child: Text(
                                      DateFormat("yyyy.MM.dd.E요일", 'ko_KR')
                                          .format(resetvationTime),
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
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              ),
                              Text(
                                "14:00 ~ 16:00(2시간)",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
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
                                    fontWeight: FontWeight.w700, fontSize: 16),
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
                                    fontWeight: FontWeight.w700, fontSize: 16),
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
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              value: Open.Yes,
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
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              value: Open.No,
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
                    ),
                    Expanded(
                        child: SizedBox(
                      width: SizeController.to.screenWidth,
                    )),
                    NextPageButton(
                      name: '예약 신청하기',
                      buttonColor: AppColor.objectColor,
                      onPressed: () {
                        Get.back();
                        eventController.addAll(_events);
                        Future.delayed(const Duration(milliseconds: 200), () {
                          _reservationConfirmDialog(context);
                        });
                      },
                    ),
                    SizedBox(
                      height: SizeController.to.screenHeight * 0.03,
                    ),
                  ],
                ),
              );
            },
          );
        });
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
