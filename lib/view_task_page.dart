import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_application/task_details_popup.dart';
import 'package:reminder_application/utils/date_utils.dart';
import 'add_task_page.dart';
import 'providers/task_provider.dart';
import 'home_page.dart';
import 'search_page.dart'; // เพิ่มการนำเข้า SearchPage

class ViewTasksPage extends StatelessWidget {
  const ViewTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('View Completed Tasks')),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final completedTasks = taskProvider.completedTasks;
          if (completedTasks.isEmpty) {
            return const Center(
              child: Text('No completed tasks.'),
            );
          }

          return ListView.builder(
            itemCount: completedTasks.length,
            itemBuilder: (context, index) {
              final task = completedTasks[index];
              return Card(
                elevation: 4,
                color: task.color ?? const Color(0xFFede3e3),
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                        formatDateRange(task.startDateTime,
                            task.endDateTime), // แสดงช่วงวันที่
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xFF000000)),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTaskPage()),
                );
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
                // Stay on this page, do nothing
              },
            ),
            const SizedBox(width: 48), // ขนาดว่างด้านขวา
          ],
        ),
      ),
    );
  }
}
