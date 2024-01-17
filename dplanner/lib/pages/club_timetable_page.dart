import 'package:dplanner/controllers/size.dart';
import 'package:dplanner/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
          WeekView(
            key: weekViewStateKey,
            controller: EventController(),
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
                        right: SizeController.to.screenWidth * 0.58),
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
                          color: AppColor.subColor4,
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

            eventTileBuilder: (date, events, boundry, start, end) {
              // Return your widget to display as event tile.
              return Container();
            },
            fullDayEventBuilder: (events, date) {
              // Return your widget to display full day event view.
              return Container();
            },
            showLiveTimeLineInAllDays:
                true, // To display live time line in all pages in week view.
            width: SizeController.to.screenWidth, // width of week view.
            minDay: DateTime(1990),
            maxDay: DateTime(2050),
            initialDay: DateTime(2024),
            heightPerMinute: SizeController.to.screenHeight *
                0.0012, // height occupied by 1 minute time span.
            eventArranger:
                SideEventArranger(), // To define how simultaneous events will be arranged.
            onEventTap: (events, date) => print(events),
            onDateLongPress: (date) => print(date),
            startDay: WeekDays.sunday, // To change the first day of the week.
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
        onPressed: () {},
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
