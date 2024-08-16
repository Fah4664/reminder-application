import 'package:intl/intl.dart';

String formatDateRange(DateTime? startDateTime, DateTime? endDateTime) {
  final dateFormat = DateFormat('d MMMM yyyy'); // รูปแบบวันที่

  if (startDateTime != null && endDateTime != null) {
    return '${dateFormat.format(startDateTime)} - ${dateFormat.format(endDateTime)}';
  } else if (startDateTime != null) {
    return '${dateFormat.format(startDateTime)} - ';
  } else if (endDateTime != null) {
    return '- ${dateFormat.format(endDateTime)}';
  } else {
    return 'Date not set';
  }
}
