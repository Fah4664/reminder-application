import 'package:intl/intl.dart';

// Function to format a date rangeใ
String formatDateRange(DateTime? startDateTime, DateTime? endDateTime) {
  // Creates a DateFormat instance to format dates in the form 'day month year'.
  final dateFormat = DateFormat('d MMMM yyyy');

  // Check if both startDateTime and endDateTime are provided.
  if (startDateTime != null && endDateTime != null) {
    // If both dates are available, return the range in the format 'start date - end date'.
    return '${dateFormat.format(startDateTime)} - ${dateFormat.format(endDateTime)}';
    // If only startDateTime is provided, return it followed by a dash to indicate the range is open-ended.
  } else if (startDateTime != null) {
    return '${dateFormat.format(startDateTime)} - ';
    // If only endDateTime is provided, return a dash followed by the end date.
  } else if (endDateTime != null) {
    return '- ${dateFormat.format(endDateTime)}';
    // If neither date is provided, return a default message 'Date not set'.
  } else {
    return 'Date not set';
  }
}