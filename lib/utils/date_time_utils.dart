import 'package:flutter/material.dart';

Future<void> selectDate(BuildContext context, bool isStart, Function(DateTime) onDateSelected) async {
  final DateTime initialDate = DateTime.now();
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );
  if (pickedDate != null) {
    onDateSelected(pickedDate);
  }
}

Future<void> selectTime(BuildContext context, bool isStart, Function(TimeOfDay) onTimeSelected) async {
  final TimeOfDay initialTime = TimeOfDay.now();
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: initialTime,
  );
  if (pickedTime != null) {
    onTimeSelected(pickedTime);
  }
}
