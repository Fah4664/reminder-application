import 'package:flutter/material.dart';
import '../models/task.dart'; // เพิ่มการ import คลาส Task


class TaskProvider with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Task> _tasks = [];
  
  // ignore: prefer_final_fields
  List<Task> _completedTasks = [];

  List<Task> get tasks => _tasks;
  List<Task> get completedTasks => _completedTasks;

  void addTask(Task task) {
    _tasks.add(task);
    saveAllTasks();
    notifyListeners();
  }

  void updateTask(int index, Task updatedTask) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
      saveAllTasks();
      notifyListeners();
    }
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    _completedTasks.remove(task);
    saveAllTasks();
    notifyListeners();
  }

  void markTaskAsCompleted(Task task) {
    if (_tasks.contains(task)) {
      _tasks.remove(task);
      _completedTasks.add(task);
      saveAllTasks();
      notifyListeners();
    }
  }

  // This method should be implemented for saving the tasks to storage
  void saveAllTasks() {
    // Implement the saving functionality here
  }
}
