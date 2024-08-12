import 'package:flutter/material.dart';
import '../models/task.dart'; // การนำเข้าคลาส Task

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _completedTasks = [];

  List<Task> get tasks => _tasks;
  List<Task> get completedTasks => _completedTasks;

  void addTask(Task task) {
    _tasks.add(task);
    saveAllTasks();
    notifyListeners(); // ทำให้แน่ใจว่า UI ได้รับการอัปเดต
  }

  void updateTask(int index, Task updatedTask) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
      saveAllTasks();
      notifyListeners(); // ทำให้แน่ใจว่า UI ได้รับการอัปเดต
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

  void saveAllTasks() {
    // Implement the saving functionality here
  }
}
