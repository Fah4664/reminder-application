// models/task.dart
class Task {
  final String title;
  final String description;
  final bool isAllDay;
  final DateTime? startDateTime;
  final DateTime? endDateTime;

  Task({
    required this.title,
    required this.description,
    this.isAllDay = false,
    this.startDateTime,
    this.endDateTime,
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
