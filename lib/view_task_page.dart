import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';

class ViewTasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('View Completed Tasks')),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final completedTasks = taskProvider.completedTasks;
          return ListView.builder(
            itemCount: completedTasks.length,
            itemBuilder: (context, index) {
              final task = completedTasks[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
