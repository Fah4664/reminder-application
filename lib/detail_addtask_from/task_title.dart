// task_form_fields.dart
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
              titleController, // Uses the provided controller for managing input.
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
          controller:
              descriptionController, // Uses the provided controller for managing input.
          decoration: const InputDecoration(
            hintText:
                'Task Description...', // Placeholder text for description.
            hintStyle: TextStyle(
              fontSize: 18,
              color: Color(0xFFd0d0d0),
            ),
            contentPadding: EdgeInsets.zero, // No padding around the content.
            border: InputBorder.none, // No border for the text field.
          ),
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
