import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'add_task_page.dart';
import 'search_page.dart';
import 'view_task_page.dart';
import 'edit_task_page.dart';
import '../models/task.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color(0xFFFFFFFF), // สีพื้นหลังของ Scaffold
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
                color: task.color ?? Colors.white, // ใช้สีของงาน หรือสีขาวถ้าไม่ได้เลือกสี
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
                height: 27,
                width: 27,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            Spacer(),
            IconButton(
              icon: Image.asset(
                'assets/icons/Add Task.png',
                height: 29,
                width: 29,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTaskPage()),
                );
              },
            ),
            Spacer(),
            IconButton(
              icon: Image.asset(
                'assets/icons/search.png',
                height: 28,
                width: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
            ),
            Spacer(),
            IconButton(
              icon: Image.asset(
                'assets/icons/View Tasks.png',
                height: 28,
                width: 28,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  task.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  task.description,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
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
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิด Dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTaskPage(
                          task: task,
                          index: index,
                        ),
                      ),
                    );
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
