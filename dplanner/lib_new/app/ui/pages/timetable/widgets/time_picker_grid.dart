import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TimeSlotStatus { available, blocked }

class TimeSlot {
  final DateTime startTime;
  TimeSlotStatus status;
  bool selected;

  TimeSlot(
      {required this.startTime, this.status = TimeSlotStatus.available, this.selected = false});
}

class TimePickerGrid extends StatelessWidget {
  final List<TimeSlot> timeSlots;
  final ValueChanged<int> onTap;
  final Color availableColor;
  final Color blockedColor;
  final Color selectedColor;
  final Color textColor;
  final Color selectedTextColor;

  const TimePickerGrid(
      {super.key,
      required this.timeSlots,
      required this.onTap,
      required this.availableColor,
      required this.blockedColor,
      required this.selectedColor,
      required this.textColor,
      required this.selectedTextColor});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.8,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final slot = timeSlots[index];
        Color bgColor;

        if (slot.status == TimeSlotStatus.blocked) {
          bgColor = blockedColor;
        } else if (slot.selected) {
          bgColor = selectedColor;
        } else {
          bgColor = availableColor;
        }

        return GestureDetector(
          onTap: slot.status == TimeSlotStatus.blocked ? null : () => onTap(index),
          child: Container(
              margin: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(DateFormat('HH:mm').format(slot.startTime),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: slot.selected ? selectedTextColor : textColor))),
        );
      },
    );
  }
}
