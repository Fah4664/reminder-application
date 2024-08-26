// task_form_fields.dart
import 'package:flutter/material.dart';

class TaskTitle extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  
  const TaskTitle({
    super.key, 
    required this.titleController, 
    required this.descriptionController,
  }); 

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            hintText: 'Task Name...',
            hintStyle: TextStyle(
              fontSize: 23,
              color: Color(0xFFd0d0d0),
            ),
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 18),
        ),
        const Divider(
          color: Color(0xFFd0d0d0),
          thickness: 1,
        ),
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
            hintText: 'Task Description...',
            hintStyle: TextStyle(
              fontSize: 18,
              color: Color(0xFFd0d0d0),
            ),
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
