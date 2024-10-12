import 'package:flutter/material.dart';
import '../detail_task_from/task_form.dart'; // Importing the TaskForm widget

// Stateless widget for adding a new task
class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key}); // Constructor with a key parameter

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0), // Adds padding around the TaskForm
        child: TaskForm(), // The TaskForm widget for task input
      ),
    );
  }
}
