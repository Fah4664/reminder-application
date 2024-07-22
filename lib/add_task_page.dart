import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/task.dart';
import 'providers/task_provider.dart';

class AddTaskPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('New Task', textAlign: TextAlign.center),
        ),
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              final String title = titleController.text;
              final String description = descriptionController.text;

              if (title.isNotEmpty && description.isNotEmpty) {
                final Task newTask = Task(
                  title: title,
                  description: description,
                );

                Provider.of<TaskProvider>(context, listen: false)
                    .addTask(newTask);
                Navigator.pop(context);
              }
            },
            child: Text(
              'Save',
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
          SizedBox(width: 20), // Add some spacing to the right of Save button
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Task Description'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
