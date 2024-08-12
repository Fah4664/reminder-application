import 'package:flutter/material.dart';

// models/task.dart
class Task {
  final String title;
  final String description;
  final bool isAllDay;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final Color? color;
  final double goalProgress;

  Task({
    required this.title,
    required this.description,
    this.isAllDay = false,
    this.startDateTime,
    this.endDateTime,
    this.color,
    required this.goalProgress,
  });

  Task copyWith({
    String? title,
    String? description,
    bool? isAllDay,
    DateTime? startDateTime,
    DateTime? endDateTime,
    Color? color,
    double? goalProgress, // เปลี่ยนที่นี่
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      isAllDay: isAllDay ?? this.isAllDay,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      color: color ?? this.color,
      goalProgress: goalProgress ?? this.goalProgress, // เปลี่ยนที่นี่
    );
  }
}