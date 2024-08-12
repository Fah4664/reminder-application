import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'add_task_page.dart';
import 'search_page.dart';
import 'view_task_page.dart';
import 'edit_task_page.dart';
import '../models/task.dart';
// import 'track_goals_box.dart'; // นำเข้า TrackGoals

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
                final newTask = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTaskPage()),
                );

                if (newTask != null) {
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
          contentPadding: const EdgeInsets.all(15.0), // Padding รอบๆ เนื้อหาภายใน AlertDialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0), // กำหนดมุมโค้งมนของ AlertDialog
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9, // ความกว้าง 90% ของหน้าจอ
            height: MediaQuery.of(context).size.height * 0.2, // ความสูง 20% ของหน้าจอ
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  task.title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
            Padding(
              padding: const EdgeInsets.all(15.0), // Padding รอบๆ ปุ่ม
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
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
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        Provider.of<TaskProvider>(context, listen: false)
                            .removeTask(task);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: MediaQuery.of(context).size.width * 0.33, // ตำแหน่งตรงกลางล่าง
                    child: TextButton(
                      onPressed: () {
                        Provider.of<TaskProvider>(context, listen: false)
                            .markTaskAsCompleted(task);
                        Navigator.of(context).pop();
                      },
                      child: Text('Mark as Completed'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }



}
