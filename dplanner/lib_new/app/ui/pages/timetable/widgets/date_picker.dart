import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../config/constants/app_colors.dart';

class DatePicker extends StatelessWidget {
  final DateTime selectedDay;
  final Function(DateTime, DateTime)? onDaySelected;
  final DateTime? rangeStartDate;
  final DateTime? rangeEndDate;

  const DatePicker(
      {super.key,
      required this.selectedDay,
      required this.onDaySelected,
      this.rangeStartDate,
      this.rangeEndDate});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
        rowHeight: 40,
        daysOfWeekHeight: 40,
        daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: Theme.of(context).textTheme.bodyLarge!,
            weekendStyle:
                Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.markColor)),
        headerStyle: HeaderStyle(
            leftChevronIcon: const Icon(SFSymbols.chevron_left, color: AppColors.textBlack),
            rightChevronIcon: const Icon(SFSymbols.chevron_right, color: AppColors.textBlack),
            titleTextStyle: Theme.of(context).textTheme.bodyLarge!,
            formatButtonVisible: false,
            titleCentered: true),
        focusedDay: selectedDay,
        firstDay: DateTime(2023, 1, 1),
        lastDay: DateTime(2099, 12, 31),
        locale: 'ko-KR',
        rangeSelectionMode: RangeSelectionMode.disabled,
        rangeStartDay: rangeStartDate,
        rangeEndDay: rangeEndDate,
        calendarStyle: CalendarStyle(
            isTodayHighlighted: false,
            defaultTextStyle: Theme.of(context).textTheme.bodyMedium!,
            outsideTextStyle:
                Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.textGray),
            weekendTextStyle:
                Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.markColor),
            selectedDecoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            selectedTextStyle:
                Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.bgWhite),
            rangeHighlightColor: AppColors.subColor2,
            rangeStartDecoration: BoxDecoration(
              color: AppColors.subColor2,
              shape: BoxShape.circle,
            ),
            rangeStartTextStyle:
                Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.bgWhite),
            rangeEndDecoration: BoxDecoration(
              color: AppColors.subColor2,
              shape: BoxShape.circle,
            ),
            rangeEndTextStyle:
                Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.bgWhite),
            withinRangeDecoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            withinRangeTextStyle:
                Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.bgWhite)),
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected);
  }
}
