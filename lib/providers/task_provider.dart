import 'package:flutter/foundation.dart';
import '../models/task.dart';


class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _completedTasks = []; // New list for completed tasks

  List<Task> get tasks => _tasks;
  List<Task> get completedTasks => _completedTasks; // Getter for completed tasks

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    _completedTasks.remove(task); // Ensure the task is also removed from completed tasks
    notifyListeners();
  }

  void markTaskAsCompleted(Task task) {
    if (_tasks.contains(task)) {
      _tasks.remove(task);
      _completedTasks.add(task); // Add task to completed tasks
      notifyListeners();
    }
  }
}