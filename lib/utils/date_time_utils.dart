import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatDate(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat("hh:mm a").format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd HH:mm").format(dateTime);
  }

  static String getTimeAgo(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return "${difference.inDays} day(s) ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hour(s) ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minute(s) ago";
    } else {
      return "Just now";
    }
  }

  static DateTime parseDate(String dateString) {
    return DateFormat("yyyy-MM-dd").parse(dateString);
  }
}
