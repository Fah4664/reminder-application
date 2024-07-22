class Task {
  final String title;
  final String description;

  Task({required this.title, required this.description});

  Task copyWith({String? title, String? description}) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
