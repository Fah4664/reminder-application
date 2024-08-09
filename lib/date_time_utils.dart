import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

Future<void> selectDateTime(BuildContext context, bool isStart, ValueChanged<DateTime?> onDateTimeSelected) async {
  final DateTime now = DateTime.now();
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: DateTime(now.year - 5),
    lastDate: DateTime(now.year + 5),
  );
  if (picked != null) {
    final TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (timePicked != null) {
      onDateTimeSelected(DateTime(picked.year, picked.month, picked.day, timePicked.hour, timePicked.minute));
    }
  }
}

Future<void> selectDate(BuildContext context, bool isStart, ValueChanged<DateTime?> onDateSelected) async {
  final DateTime now = DateTime.now();
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: DateTime(now.year - 5),
    lastDate: DateTime(now.year + 5),
  );
  if (picked != null) {
    onDateSelected(picked);
  }
}
