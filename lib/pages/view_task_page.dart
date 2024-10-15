import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:reminder_application/utils/date_utils.dart';
import 'package:reminder_application/task_details_popup.dart';
import '../providers/task_provider.dart';
import '../utils/color_utils.dart';
import 'home_page.dart';
import 'add_task_page.dart';
import 'search_page.dart';

// Define the ViewTasksPage as a StatelessWidget.
class ViewTasksPage extends StatelessWidget {
  const ViewTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('View Completed Tasks')), // AppBar title.
        automaticallyImplyLeading: false, // Do not show leading button.
      ),
      body: Consumer<TaskProvider>(
        // Listen to changes in TaskProvider.
        builder: (context, taskProvider, child) {
          final completedTasks = taskProvider.completedTasks; // Get completed tasks from provider.
          if (completedTasks.isEmpty) {
            // Check if there are no completed tasks.
            return const Center(
              child: Text('No completed tasks.'), // Display message if no tasks.
            );
          }

          return ListView.builder(
            // Create a list view to display completed tasks.
            itemCount: completedTasks.length, // Number of completed tasks.
            itemBuilder: (context, index) {
              // Build each item in the list
              final task = completedTasks[index]; // Get the task at the current index.
              return Card(
                elevation: 4, // Shadow effect for the card.
                color: task.color != null // Use task color if available.
                    ? colorFromString(task.color!)
                    : const Color(0xFFede3e3), // Default color if not set
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Margin around card.
                child: ListTile(
                  title: Column(
                    // Column to display task details.
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [
                      Text(
                        task.title, // Display task title.
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), 
                      ),
                      const SizedBox(height: 5), 
                      Text(
                        formatDateRange(task.startDateTime, task.endDateTime), // Show date range.
                        style: const TextStyle(fontSize: 16, color: Color(0xFF000000)), 
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
                            // Calculate width based on slider value.
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
      bottomNavigationBar: BottomAppBar(
        // Bottom navigation bar.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: <Widget>[
            const SizedBox(width: 48),
            IconButton(
              icon: Image.asset('assets/icons/target.png', height: 27, width: 27), 
              onPressed: () {
                Navigator.push(
                  // Navigate to HomePage when pressed.
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            const Spacer(), 
            IconButton(
              icon: Image.asset('assets/icons/Add Task.png', height: 29, width: 29),
              onPressed: () {
                Navigator.push(
                  // Navigate to AddTaskPage when pressed
                  context,
                  MaterialPageRoute(builder: (context) => const AddTaskPage()),
                );
              },
            ),
            const Spacer(),
            IconButton(
              icon: Image.asset('assets/icons/search.png', height: 28, width: 28), 
              onPressed: () {
                Navigator.push(
                  // Navigate to SearchPage when pressed.
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                );
              },
            ),
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                'assets/icons/View Tasks.png', 
                height: 28,
                width: 28,
              ),
              const Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 15, 
                    color: Colors.black, 
                  ),
                ),
              ],
            ),
            const SizedBox(width: 48), 
          ],
        ),
      ),
    );
  }
}