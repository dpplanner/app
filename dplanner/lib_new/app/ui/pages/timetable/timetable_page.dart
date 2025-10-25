import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../data/model/club/club_authority_type.dart';
import '../../../data/model/resource/resource.dart';
import '../../base/pages/error_page.dart';
import '../../base/pages/loading_page.dart';
import '../../base/widgets/ad_banner.dart';
import '../../base/widgets/base_appbar.dart';
import '../../base/widgets/base_bottom_bar.dart';
import '../../base/widgets/buttons/custom_floating_action_button.dart';
import '../../base/widgets/padded_safe_area.dart';
import '../../base/widgets/buttons/custom_dropdown_button.dart';
import 'timetable_controller.dart';

class TimetablePage extends GetView<TimetableController> {
  const TimetablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      appBar: BaseAppBar(
        leadingType: LeadingType.BACK,
        title: const Text("예약 시간표"),
      ),
      body: PaddedSafeArea(
          child: FutureBuilder(
              future: controller.initialize(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const ErrorPage();
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingPage();
                } else if (controller.resources.isEmpty) {
                  return LayoutBuilder(builder: (context, constraints) {
                    return Column(
                      children: [
                        const AdBanner(),
                        Container(
                          color: AppColors.bgWhite,
                          height: constraints.maxHeight - 50,
                          width: constraints.maxWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("아직 클럽 공유 물품이 없어요",
                                  style: Theme.of(context).textTheme.titleMedium),
                              if (controller.me.value!.hasAuthority(ClubAuthorityType.RESOURCE_ALL))
                                Column(
                                  children: [
                                    Text("공유 물품을 추가할까요?",
                                        style: Theme.of(context).textTheme.titleMedium),
                                    TextButton(
                                      onPressed: controller.toResourceListPage,
                                      style: const ButtonStyle(
                                          overlayColor: WidgetStateColor.transparent),
                                      child: Text("추가하기",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: AppColors.primaryColor)),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  });
                } else {
                  const timelineWidth = 20.0;
                  return Column(
                    children: [
                      const AdBanner(),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                    width: timelineWidth,
                                    child: Container(color: AppColors.bgWhite)),
                                Expanded(child: Container(color: AppColors.bgPrimary)),
                              ],
                            ),
                            Center(
                              child: WeekView(
                                key: controller.weekViewStateKey,
                                controller: controller.eventController,

                                // 캘린더 기본 속성
                                minDay: DateTime(2020),
                                maxDay: DateTime(2099),
                                initialDay: DateTime.now(),
                                startDay: WeekDays.monday,

                                // 캘린더 ui 속성
                                backgroundColor: AppColors.transparent,
                                hourIndicatorSettings:
                                    HourIndicatorSettings(color: AppColors.bgWhite, height: 0.7),
                                showLiveTimeLineInAllDays: true,
                                liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
                                    offset: 1, bulletRadius: 3, color: AppColors.primaryColor),
                                pageTransitionDuration: const Duration(milliseconds: 300),
                                pageTransitionCurve: Curves.linear,
                                minuteSlotSize: MinuteSlotSize.minutes60,
                                keepScrollOffset: true,

                                // 1행 (날짜 + 요일)
                                weekTitleHeight: 60,
                                weekPageHeaderBuilder: (DateTime startDate, DateTime endDate) {
                                  return Container(
                                    color: AppColors.bgWhite,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IntrinsicWidth(
                                          child: WeekPageHeader(
                                              headerStringBuilder: (DateTime dateTime,
                                                  {DateTime? secondaryDate}) {
                                                return DateFormat("MM월").format(dateTime);
                                              },
                                              headerStyle: HeaderStyle(
                                                  headerPadding: const EdgeInsets.only(right: 12),
                                                  decoration:
                                                      BoxDecoration(color: AppColors.transparent),
                                                  headerTextStyle:
                                                      Theme.of(context).textTheme.titleMedium,
                                                  titleAlign: TextAlign.start,
                                                  leftIconConfig: IconDataConfig(
                                                      size: 24,
                                                      icon: (context) {
                                                        return IconButton(
                                                            onPressed: controller.moveToCurrentWeek,
                                                            icon: Icon(SFSymbols.calendar,
                                                                color: AppColors.textBlack));
                                                      }),
                                                  rightIconConfig: null),
                                              startDate: startDate,
                                              endDate: endDate,
                                              onTitleTapped: controller.changeWeek),
                                        ),
                                        Obx(
                                          () => CustomDropdownButton<Resource>(
                                              items: controller.resources,
                                              itemLabelBuilder: (resource) => resource.name,
                                              initialValue: controller.currentResource.value,
                                              onChanged: (resource) =>
                                                  controller.changeResource(resource)),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                weekNumberBuilder: (date) => Container(color: AppColors.bgWhite),
                                weekDayBuilder: (DateTime date) {
                                  final isToday = date.isAtSameMomentAs(DateTime.now().withoutTime);
                                  final isFirstDayOfMonth = date.day == 1;

                                  return Container(
                                      color: AppColors.bgWhite,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          isToday
                                              ? Text('오늘',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(color: AppColors.markColor))
                                              : isFirstDayOfMonth
                                                  ? Text(DateFormat("M/d").format(date),
                                                      style:
                                                          Theme.of(context).textTheme.titleMedium)
                                                  : Text(DateFormat.d().format(date),
                                                      style:
                                                          Theme.of(context).textTheme.titleMedium),
                                          Text(DateFormat('E', 'ko_KR').format(date),
                                              style: isToday
                                                  ? Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(color: AppColors.markColor)
                                                  : Theme.of(context).textTheme.bodyMedium)
                                        ],
                                      ));
                                },

                                // 1열 (시각)
                                timeLineOffset: 10,
                                timeLineWidth: timelineWidth,
                                timeLineBuilder: (DateTime date) {
                                  final hour = date.hour.toString().padLeft(2, '0');
                                  return Text(hour,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: AppColors.textGray));
                                },

                                // 이벤트 속성
                                eventTileBuilder: (date, events, boundary, start, end) {
                                  if (events.isNotEmpty) {
                                    final isNotConfirmed =
                                        events[0].color == ReservationColors.notConfirmed;
                                    return Container(
                                      decoration: BoxDecoration(
                                          border:
                                              isNotConfirmed && controller.hasScheduleAuthority()
                                                  ? Border.all(
                                                      color: AppColors.primaryColor, width: 2.0)
                                                  : Border.all(
                                                      color: AppColors.transparent, width: 0.0)),
                                      child: RoundedEventTile(
                                        title: events[0].title.split(" ").sublist(1).join(" "),
                                        titleStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: AppColors.bgWhite, wordSpacing: 20),
                                        description: events[0].description,
                                        descriptionStyle: Theme.of(context).textTheme.bodyMedium,
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
                                    boxConstraints: const BoxConstraints(maxHeight: 65),
                                    date: date,
                                  );
                                },
                                eventArranger: const SideEventArranger(),

                                // actions
                                onEventTap: controller.onEventTab,
                                onEventLongTap: controller.onEventLongTab,
                                onEventDoubleTap: controller.onEventDoubleTab,
                                onPageChange: controller.onPageChange,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }
              })),
      floatingActionButton: FutureBuilder(
          future: controller.initialize(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else {
              return Visibility(
                  visible: controller.hasScheduleAuthority(),
                  replacement: CustomFloatingActionButton.single(
                      iconData: SFSymbols.plus, onPressed: controller.requestReservation),
                  child: CustomFloatingActionButton.multi(actions: {
                    SFSymbols.lock: controller.lockResource,
                    SFSymbols.plus: controller.requestReservation
                  }));
            }
          }),
      bottomNavigationBar: const BaseBottomBar(),
    );
  }
}
