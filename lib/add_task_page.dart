import 'package:flutter/material.dart';
import 'task_form.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: TaskForm(),
      ),
    );
  }
}
