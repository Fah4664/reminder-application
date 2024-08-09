// providers/task_provider.dart
import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _completedTasks = [];

  List<Task> get tasks => _tasks;
  List<Task> get completedTasks => _completedTasks;

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
    _completedTasks.remove(task);
    notifyListeners();
  }

  void markTaskAsCompleted(Task task) {
    if (_tasks.contains(task)) {
      _tasks.remove(task);
      _completedTasks.add(task);
      notifyListeners();
    }
  }
}
