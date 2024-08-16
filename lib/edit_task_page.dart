import 'package:flutter/material.dart';
import 'models/task.dart';
import 'task_form.dart';

class EditTaskPage extends StatelessWidget {
  final Task task;

  const EditTaskPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TaskForm(initialTask: task),
      ),
    );
  }
}
