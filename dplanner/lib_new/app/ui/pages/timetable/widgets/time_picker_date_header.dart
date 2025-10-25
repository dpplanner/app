import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePickerDateHeader extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onCalendarTap;

  const TimePickerDateHeader({
    super.key,
    required this.selectedDate,
    required this.onPrev,
    required this.onNext,
    required this.onCalendarTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(selectedDate);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: Icon(Icons.chevron_left), onPressed: onPrev),
        GestureDetector(
          onTap: onCalendarTap,
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 16),
              SizedBox(width: 6),
              Text(dateStr, style: Theme.of(context).textTheme.titleMedium)
            ],
          ),
        ),
        IconButton(icon: Icon(Icons.chevron_right), onPressed: onNext),
      ],
    );
  }
}