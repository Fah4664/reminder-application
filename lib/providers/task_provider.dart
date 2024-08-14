import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];
  final List<Task> _completedTasks = [];

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

  void updateTaskProgress(int index, double newProgress) {
    if (index >= 0 && index < _tasks.length) {
      // Create a new Task with the updated progress
      Task updatedTask = _tasks[index].copyWith(goalProgress: newProgress);
      // Update the task in the list
      _tasks[index] = updatedTask;
      saveAllTasks();
      notifyListeners();
    }
  }

  void saveAllTasks() {
    // Implement the saving functionality here
  }
}
