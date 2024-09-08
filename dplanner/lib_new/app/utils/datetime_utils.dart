import 'package:intl/intl.dart';

class DateTimeUtils {
  static const String _dateTimeFormat = "yyyy-MM-dd HH:mm:ss";

  static String toFormattedString(DateTime dateTime) {
    return DateFormat(_dateTimeFormat).format(dateTime);
  }
}