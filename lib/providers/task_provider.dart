import 'package:flutter/foundation.dart';
import '../models/task.dart';


class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks.where((task) => !task.isCompleted).toList(); // Filter out completed tasks

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void markTaskAsCompleted(Task task) {
    final index = _tasks.indexOf(task);
    if (index != -1) {
      _tasks[index] = Task(
        title: task.title,
        description: task.description,
        isCompleted: true, // Mark task as completed
      );
      notifyListeners();
    }
  }
}