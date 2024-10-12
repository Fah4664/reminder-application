import 'package:flutter/material.dart';
import '../models/task.dart'; // Importing the Task model
import '../detail_task_from/task_form.dart'; // Importing the TaskForm widget for editing tasks

// Stateless widget for editing an existing task
class EditTaskPage extends StatelessWidget {
  final Task task; // A Task object representing the task to be edited

  const EditTaskPage(
      {super.key, required this.task}); // Constructor that requires a Task

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds padding around the TaskForm
        child: TaskForm(
            initialTask: task), // Passes the task to TaskForm for editing
      ),
    );
  }
}
