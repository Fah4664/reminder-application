import 'package:flutter/material.dart';
import '../detail_task_from/task_form.dart';

// Stateless widget for adding a new task
class AddTaskPage extends StatelessWidget {
  // Constructor with a key parameter
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        // Adds padding around the TaskForm
        padding: EdgeInsets.all(16.0),
        // The TaskForm widget for task input
        child: TaskForm(),
      ),
    );
  }
}
