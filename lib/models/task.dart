//import 'package:flutter/material.dart';

class Task {
  String id; // เพิ่ม id
  String title;
  String description;
  bool isAllDay;
  DateTime? startDateTime;
  DateTime? endDateTime;
  String notificationOption;
  String? color; // เปลี่ยนเป็น String สำหรับการจัดเก็บใน Firestore
  double sliderValue;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isAllDay = false,
    required this.startDateTime,
    required this.endDateTime,
    this.notificationOption = 'None',
    this.color, // ใช้ String แทน Color
    required this.sliderValue,
  });

  // Getter สำหรับตรวจสอบสถานะว่า task เสร็จสมบูรณ์หรือไม่
  bool get isCompleted => sliderValue >= 100.0;

  // ฟังก์ชันสำหรับแปลง Task เป็น Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isAllDay': isAllDay,
      'startDateTime': startDateTime?.toIso8601String(),
      'endDateTime': endDateTime?.toIso8601String(),
      'notificationOption': notificationOption,
      'color': color,
      'sliderValue': sliderValue,
    };
  }

  // ฟังก์ชันสำหรับสร้าง Task จาก Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isAllDay: map['isAllDay'] as bool? ?? false,
      startDateTime: map['startDateTime'] != null ? DateTime.parse(map['startDateTime'] as String) : null,
      endDateTime: map['endDateTime'] != null ? DateTime.parse(map['endDateTime'] as String) : null,
      notificationOption: map['notificationOption'] as String? ?? 'None',
      color: map['color'] as String?, // แปลงจาก String เป็น Color เมื่ออ่านจาก Firestore
      sliderValue: map['sliderValue'] as double,
    );
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isAllDay,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? notificationOption,
    String? color,
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
