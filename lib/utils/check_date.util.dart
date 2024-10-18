import 'package:intl/intl.dart';

class CheckDate {
  static String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);

    return DateFormat('dd/MM/yyyy').format(date); 
  }

  static bool isSameDay(String date1, String date2) {
    DateTime dateTime1 = DateTime.parse(date1);
    DateTime dateTime2 = DateTime.parse(date2);

    return dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day;
  }
}
