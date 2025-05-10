import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  return "${dateTime.day.toString().padLeft(2, '0')} "
      "${_monthName(dateTime.month)} "
      "${dateTime.year}";
}

String _monthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return months[month - 1];
}

String formatTime(DateTime dateTime) {
  return DateFormat('hh:mm a').format(dateTime);
}

String dateFormatter(dynamic data) {
  if (data != null) {
    try {
      return DateFormat('MMMM d, y').format(data.toDate());
    } catch (e) {
      return '';
    }
  }
  return '';
}
