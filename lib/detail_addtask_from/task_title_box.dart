import 'package:flutter/material.dart';

// Widget for inputting task title and description.
class TaskTitle extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  // Constructor accepting required controllers for title and description.
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
        // Text field for task title.
        TextField(
          controller:
            // Uses the provided controller for managing input.
            titleController,
          decoration: const InputDecoration(
            // Placeholder text for task title.
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
          controller:
            // Uses the provided controller for managing input.
            descriptionController,
          decoration: const InputDecoration(
            // Placeholder text for description.
            hintText:
              'Task Description...',
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
