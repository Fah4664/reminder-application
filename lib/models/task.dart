import 'package:flutter/material.dart';

class Task {
  String id; // เพิ่ม id
  String title;
  String description;
  bool isAllDay;
  DateTime? startDateTime;
  DateTime? endDateTime;
  String notificationOption;
  Color? color;
  double sliderValue;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isAllDay = false,
    required this.startDateTime,
    required this.endDateTime,
    this.notificationOption = 'None',
    required this.color,
    required this.sliderValue,
  });

  // Getter สำหรับตรวจสอบสถานะว่า task เสร็จสมบูรณ์หรือไม่
  bool get isCompleted => sliderValue >= 100.0;

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isAllDay,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String ? notificationOption,
    Color? color,
    double? sliderValue,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isAllDay: isAllDay ?? this.isAllDay,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      notificationOption: notificationOption ?? this.notificationOption,
      color: color ?? this.color,
      sliderValue: sliderValue ?? this.sliderValue,
    );
  }
}
