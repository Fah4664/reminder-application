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
        title: Text('Add Task'),
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
            ElevatedButton(
              onPressed: () {
                final String title = titleController.text;
                final String description = descriptionController.text;

                if (title.isNotEmpty && description.isNotEmpty) {
                  final Task newTask = Task(
                    title: title,
                    description: description,
                  );

                  Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
                  Navigator.pop(context);
                }
              },
              child: Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}