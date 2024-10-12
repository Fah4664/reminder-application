import 'package:flutter/material.dart';
import '../models/task.dart';
import '../detail_task_from/task_form.dart'; 

// Stateless widget for editing an existing task
class EditTaskPage extends StatelessWidget {
  // A Task object representing the task to be edited
  final Task task;
  // Constructor that requires a Task
  const EditTaskPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        // Adds padding around the TaskForm
        padding: const EdgeInsets.all(16.0),
        // Passes the task to TaskForm for editing
        child: TaskForm(
          initialTask: task),
      ),
    );
  }
}
