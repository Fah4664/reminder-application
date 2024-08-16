import 'package:flutter/material.dart';
import 'task_form.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        automaticallyImplyLeading: false, // ปิดการแสดงปุ่มย้อนกลับ
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: TaskForm(),
      ),
    );
  }
}
