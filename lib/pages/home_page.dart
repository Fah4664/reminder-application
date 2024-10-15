import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/date_utils.dart';
import '../utils/color_utils.dart';
import '../task_details_popup.dart';
import 'login_page.dart';
import 'add_task_page.dart';
import 'search_page.dart';
import 'view_task_page.dart';

// HomePage that displays the list of tasks
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load all tasks when the page is initialized
    Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // Set background to white
      appBar: AppBar(
        title: const Center(
          child: Text('Track Goals')), // App title shown in the top bar
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: const Icon(Icons.logout), // Log out button
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut(); // Sign out
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                } catch (e) {
                  // Show error message if sign-out fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error signing out: $e')),
                  );
                }
              }),
        ],
      ),
      // Use StreamBuilder to listen for task changes
      body: StreamBuilder<List<Task>>(
        stream: Provider.of<TaskProvider>(context).tasksStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator()); // Show loading spinner when data is being fetched
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}')); // Show error message
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No tasks added yet.')); // Show message when no tasks are available
          }
          // Filter and show only incomplete tasks
          final tasks = snapshot.data!.where((task) => !task.isCompleted).toList();
          return ListView.builder(
            itemCount: tasks.length, // Number of tasks to display
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                elevation: 4,
                color: task.color != null
                    ? colorFromString(task.color!) // Set card color based on task.
                    : const Color(0xFFede3e3),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display task title.
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      // Display task date range.
                      Text(
                        formatDateRange(task.startDateTime, task.endDateTime),
                        style: const TextStyle(
                          fontSize: 16, color: Color(0xFF000000)),
                      ),
                      const SizedBox(height: 5),
                      // Task progress bar.
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
                            // Progress bar width based on sliderValue.
                            width: (MediaQuery.of(context).size.width - 100) * (task.sliderValue * 100 / 150),
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
                    // Show task details popup when tapped.
                    showTaskDetailsPopup(context, task, index);
                  },
                ),
              );
            },
          );
        },
      ),
      // Bottom navigation bar
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: 48),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/target.png',
                  height: 27,
                  width: 27,
                ),
                const Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
                icon: Image.asset(
                  'assets/icons/Add Task.png',
                  height: 29,
                  width: 29,
                ),
                onPressed: () async {
                  final taskProvider =
                    Provider.of<TaskProvider>(context, listen: false);
                  // Open AddTaskPage and receive a new task
                  final newTask = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTaskPage()));
                  if (newTask != null) {
                    taskProvider.addTask(newTask); // Add the new task to the list
                  }
                }),
            const Spacer(),
            IconButton(
              icon: Image.asset(
                'assets/icons/search.png',
                height: 28,
                width: 28,
              ),
              onPressed: () {
                // Open SearchPage
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
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
                // Open ViewTasksPage for completed tasks
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewTasksPage()));
              },
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}