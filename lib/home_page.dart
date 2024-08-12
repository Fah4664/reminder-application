import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'add_task_page.dart';
import 'search_page.dart';
import 'view_task_page.dart';
import 'edit_task_page.dart';
import '../models/task.dart';
//import 'track_goals_box.dart'; // นำเข้า TrackGoals

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // สีพื้นหลังของ Scaffold
      appBar: AppBar(
        title: const Center(child: Text('Track Goals')),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.tasks.isEmpty) {
            return const Center(
              child: Text('No tasks added yet.'),
            );
          }

          return ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return Card(
                elevation: 4,
                color: task.color ?? const Color(0xFFede3e3), // ใช้สีของงาน หรือสีเริ่มต้นถ้าไม่ได้เลือกสี
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${task.startDateTime?.day}/${task.startDateTime?.month}/${task.startDateTime?.year} - ${task.endDateTime?.day}/${task.endDateTime?.month}/${task.endDateTime?.year}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  
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
            const SizedBox(width: 48), // ขนาดว่างด้านซ้าย
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
              onPressed: () async {
                // รับผลลัพธ์จาก AddTaskPage
                final newTask = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTaskPage()),
                );

                if (newTask != null) {
                  // ถ้ามีการเพิ่มงานใหม่ให้ทำการอัปเดตรายการงานในหน้า HomePage
                  Provider.of<TaskProvider>(context, listen: false)
                      .addTask(newTask);
                }
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
