import 'package:flutter/material.dart';

Future<void> selectDate(BuildContext context, bool isStart, Function(DateTime) onSelected) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );
  if (picked != null) {
    onSelected(picked);
  }
}

Future<void> selectTime(BuildContext context, bool isStart, Function(TimeOfDay) onSelected) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (picked != null) {
    onSelected(picked);
  }
}
