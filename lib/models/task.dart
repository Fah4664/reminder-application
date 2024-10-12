// Model class representing a Task.
class Task {
  // Properties of the Task class.
  String id; // Unique identifier for the task.
  String title; // Title of the task.
  String description; // Description of the task.
  bool isAllDay; // Indicates if the task lasts all day.
  DateTime? startDateTime; // Start date and time for the task.
  DateTime? endDateTime; // End date and time for the task.
  String notificationOption; // Option for task notifications.
  String? color; // Color associated with the task.
  double sliderValue; // Value of the slider, indicating progress of the task.
  bool isCompleted; // Indicates if the task is completed.

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isAllDay = false, // Default value is false.
    required this.startDateTime,
    required this.endDateTime,
    this.notificationOption = 'None', // Default notification option is 'None'.
    this.color,
    required this.sliderValue,
    this.isCompleted = false, // Default value is false.
  });

  // Function to convert Task to a Map for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isAllDay': isAllDay,
      'startDateTime': startDateTime?.toIso8601String(), // Converts DateTime to ISO 8601 string format.
      'endDateTime': endDateTime?.toIso8601String(),
      'notificationOption': notificationOption,
      'color': color,
      'sliderValue': sliderValue,
      'isCompleted': isCompleted,
    };
  }

  // Method to create a Task instance from a Map for database retrieval.
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isAllDay: map['isAllDay'] as bool? ?? false, // Default to false if not present.
      startDateTime: map['startDateTime'] != null
          ? DateTime.parse(map['startDateTime'] as String) // Parse DateTime from string.
          : null,
      endDateTime: map['endDateTime'] != null
          ? DateTime.parse(map['endDateTime'] as String)
          : null,
      notificationOption: map['notificationOption'] as String? ?? 'None',
      color: map['color']
          as String?,
      sliderValue: map['sliderValue'] as double,
      isCompleted: map['isCompleted'] ?? false, // Default to false if not present.
    );
  }

  // Method to create a copy of the Task with optional updated fields.
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
    bool? isCompleted,
  }) {
    return Task(
      // Keep current value if not provided.
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isAllDay: isAllDay ?? this.isAllDay,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      notificationOption: notificationOption ?? this.notificationOption,
      color: color ?? this.color,
      sliderValue: sliderValue ?? this.sliderValue,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
