import 'package:flutter/material.dart';

// models/task.dart
class Task {
  final String title;
  final String description;
  final bool isAllDay;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final Color? color; // เพิ่ม property นี้

  Task({
    required this.title,
    required this.description,
    this.isAllDay = false,
    this.startDateTime,
    this.endDateTime,
    this.color, // เพิ่ม property นี้
  });

  Task copyWith({
    String? title,
    String? description,
    bool? isAllDay,
    DateTime? startDateTime,
    DateTime? endDateTime,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      isAllDay: isAllDay ?? this.isAllDay,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
    );
  }
}
