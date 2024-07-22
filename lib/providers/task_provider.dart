import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(int index, Task updatedTask) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void markTaskAsCompleted(Task task) {
    // Implement completion logic if needed
    notifyListeners();
  }
}