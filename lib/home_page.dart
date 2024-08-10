import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'add_task_page.dart';
import 'search_page.dart';
import 'view_task_page.dart'; // Import the ViewTasksPage
import 'edit_task_page.dart'; // Import the EditTaskPage
import '../models/task.dart'; // Import the Task model

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Track Goals')),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  onTap: () {
                    _showTaskDetailsDialog(context, task, index);
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 48), // ขนาดว่างด้านซ้าย
            IconButton(
              icon: Image.asset(
                'assets/icons/target.png',
                height: 24,
                width: 24,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTaskPage()),
                );
              },
            ),
            Spacer(), // ช่องว่างที่จัดระเบียบ
            IconButton(
              icon: Image.asset(
                'assets/icons/Add Task.png',
                height: 24,
                width: 24,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTaskPage()),
                );
              },
            ),
            Spacer(), // ช่องว่างที่จัดระเบียบ
            IconButton(
              icon: Image.asset(
                'assets/icons/search.png',
                height: 24,
                width: 24,
              ),
              onPressed: () async {
                final selectedTask = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );

                if (selectedTask != null && selectedTask is Task) {
                  _showTaskDetailsDialog(
                      context,
                      selectedTask,
                      Provider.of<TaskProvider>(context, listen: false)
                          .tasks
                          .indexOf(selectedTask));
                }
              },
            ),
            Spacer(), // ช่องว่างที่จัดระเบียบ
            IconButton(
              icon: Image.asset(
                'assets/icons/View Tasks.png',
                height: 24,
                width: 24,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewTasksPage()),
                );
              },
            ),
            SizedBox(width: 48), // ขนาดว่างด้านขวา
          ],
        ),
      ),
    );
  }

  void _showTaskDetailsDialog(BuildContext context, Task task, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      task.title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      task.description,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pop(); // ปิด dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTaskPage(
                            task: task,
                            index: index, // ส่งดัชนีที่นี่
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<TaskProvider>(context, listen: false)
                        .markTaskAsCompleted(task);
                    Navigator.of(context).pop();
                  },
                  child: Text('Mark as Completed'),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Provider.of<TaskProvider>(context, listen: false)
                        .removeTask(task);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
