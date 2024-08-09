// models/task.dart
class Task {
  final String title;
  final String description;
  final bool isAllDay; // เพิ่มพารามิเตอร์นี้
  final DateTime? startDateTime;
  final DateTime? endDateTime;

  Task({
    required this.title,
    required this.description,
    this.isAllDay = false, // ค่าเริ่มต้นเป็น false
    this.startDateTime,
    this.endDateTime,
  });

  Task copyWith({
    String? title,
    String? description,
    bool? isAllDay, // เพิ่มพารามิเตอร์นี้
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      isAllDay: isAllDay ?? this.isAllDay, // คัดลอกค่าของ isAllDay
    );
  }
}