import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'home_page.dart';
import 'add_task_page.dart';
import 'search_page.dart';

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
          return completedTasks.isEmpty
              ? Center(
                  child: Text(
                    'No completed tasks found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) {
                    final task = completedTasks[index];
                    return Card(
                      elevation: 4,
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: ListTile(
                        title: Text(task.title),
                        subtitle: Text(task.description),
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
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            Spacer(),
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
            Spacer(),
            IconButton(
              icon: Image.asset(
                'assets/icons/search.png',
                height: 24,
                width: 24,
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
                height: 24,
                width: 24,
              ),
              onPressed: () {
                // Stay on this page, do nothing
              },
            ),
            SizedBox(width: 48), // ขนาดว่างด้านขวา
          ],
        ),
      ),
    );
  }
}
