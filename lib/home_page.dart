// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'add_task_page.dart';
import 'search_page.dart';
import 'view_task_page.dart';
//import 'edit_task_page.dart';
//import '../models/task.dart';
import 'task_details_popup.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                color: task.color ??
                    const Color(
                        0xFFede3e3), // ใช้สีของงาน หรือสีเริ่มต้นถ้าไม่ได้เลือกสี
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
                    showTaskDetailsDialog(context, task, index);
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
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            const Spacer(),
            IconButton(
              icon: Image.asset(
                'assets/icons/Add Task.png',
                height: 29,
                width: 29,
              ),
              onPressed: () async {
                final newTask = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddTaskPage()),
                );

                if (newTask != null) {
                  Provider.of<TaskProvider>(context, listen: false)
                      .addTask(newTask);
                }
              },
            ),
            const Spacer(),
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
            const Spacer(),
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
            const SizedBox(width: 48), // ขนาดว่างด้านขวา
          ],
        ),
      ),
    );
  }

}
