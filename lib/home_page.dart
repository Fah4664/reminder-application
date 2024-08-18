import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
//import 'package:intl/intl.dart';
import 'add_task_page.dart';
import 'search_page.dart';
import 'view_task_page.dart';
//import 'edit_task_page.dart';
import '../models/task.dart';
import 'task_details_popup.dart';
import 'utils/date_utils.dart';

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
              // จัดเรียง task ตามวันที่สิ้นสุด
              final sortedTasks = List<Task>.from(taskProvider.tasks)
                ..sort((a, b) => a.endDateTime!.compareTo(b.endDateTime!));
              final task = sortedTasks[index];

              return Card(
                elevation: 4,
                color: task.color ?? const Color(0xFFede3e3),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        formatDateRange(task.startDateTime, task.endDateTime),
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color(
                                0xFF000000)), // เปลี่ยนสีข้อความให้เหมาะสมกับพื้นหลัง
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 200,
                        height: 15,
                        decoration: BoxDecoration(
                          color: const Color(0xFFd0d0d0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: (MediaQuery.of(context).size.width - 100) *
                                (task.sliderValue * 100 / 150),
                            height: 15,
                            decoration: BoxDecoration(
                              color: const Color(0xFF717273),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    showTaskDetailsPopup(context, task, index); // ใช้สีจาก Task
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
                Navigator.pushReplacement(
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
                // เก็บ TaskProvider ไว้ในตัวแปรก่อนที่จะมี async gap
                final taskProvider = Provider.of<TaskProvider>(context, listen: false);
                final newTask = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddTaskPage()),
                );
                if (newTask != null) {
                  taskProvider.addTask(newTask);
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
                  MaterialPageRoute(builder: (context) => const SearchPage()),
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
                  MaterialPageRoute(
                      builder: (context) => const ViewTasksPage()),
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
