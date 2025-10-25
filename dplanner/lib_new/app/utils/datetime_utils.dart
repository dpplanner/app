import 'package:intl/intl.dart';

class DateTimeUtils {
  static const String _dateTimeFormat = "yyyy-MM-dd HH:mm:ss";

  static String toFormattedString(DateTime dateTime) {
    return DateFormat(_dateTimeFormat).format(dateTime);
  }
}

extension CopyableDateTime on DateTime {
  DateTime copyWithDate(DateTime dateCopyTarget) {
    return copyWith(
        year: dateCopyTarget.year, month: dateCopyTarget.month, day: dateCopyTarget.day);
  }

  DateTime copyWithTime(DateTime timeCopyTarget) {
    return copyWith(
        hour: timeCopyTarget.hour, minute: timeCopyTarget.minute, second: timeCopyTarget.second);
  }
}

extension DateTimeRange on DateTime {
  DateTime get withoutMinute => copyWith(minute: 0, second: 0, microsecond: 0, millisecond: 0);

  bool isWithin(DateTime start, DateTime end) {
    return isAfter(start) && isBefore(end);
  }
}
