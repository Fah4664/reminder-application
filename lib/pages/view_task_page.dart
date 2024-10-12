import 'package:flutter/material.dart'; // Import Flutter material design library
import 'package:provider/provider.dart'; // Import provider package for state management
import 'package:reminder_application/utils/date_utils.dart'; // Import date utility functions
import 'add_task_page.dart'; // Import the page to add new tasks
import '../providers/task_provider.dart'; // Import task provider for state management
import 'home_page.dart'; // Import home page
import 'search_page.dart'; // Import search page
import '../utils/color_utils.dart'; // Import color utility functions
import 'package:reminder_application/task_details_popup.dart'; // Import the file where showTaskDetailsPopup is defined

// Define the ViewTasksPage as a StatelessWidget
class ViewTasksPage extends StatelessWidget {
  const ViewTasksPage({super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('View Completed Tasks')), // AppBar title
        automaticallyImplyLeading: false, // Do not show leading button
      ),
      body: Consumer<TaskProvider>(
        // Listen to changes in TaskProvider
        builder: (context, taskProvider, child) {
          final completedTasks = taskProvider.completedTasks; // Get completed tasks from provider
          if (completedTasks.isEmpty) {
            // Check if there are no completed tasks
            return const Center(
              child: Text('No completed tasks.'), // Display message if no tasks
            );
          }

          return ListView.builder(
            // Create a list view to display completed tasks
            itemCount: completedTasks.length, // Number of completed tasks
            itemBuilder: (context, index) {
              // Build each item in the list
              final task = completedTasks[index]; // Get the task at the current index
              return Card(
                elevation: 4, // Shadow effect for the card
                color: task.color != null // Use task color if available
                    ? colorFromString(task.color!)
                    : const Color(0xFFede3e3), // Default color if not set
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Margin around card
                child: ListTile(
                  title: Column(
                    // Column to display task details
                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                    children: [
                      Text(
                        task.title, // Display task title
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Title style
                      ),
                      const SizedBox(height: 5), // Spacer
                      Text(
                        formatDateRange(task.startDateTime, task.endDateTime), // Show date range
                        style: const TextStyle(fontSize: 16, color: Color(0xFF000000)), // Date style
                      ),
                      const SizedBox(height: 5), // Spacer
                      Container(
                        width: 200, // Width of the progress bar
                        height: 15, // Height of the progress bar
                        decoration: BoxDecoration(
                          color: const Color(0xFFd0d0d0), // Background color of the progress bar
                          borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft, // Align progress indicator to the left
                          child: Container(
                            width: (MediaQuery.of(context).size.width - 100) * (task.sliderValue * 100 / 150), // Calculate width based on slider value
                            height: 15, // Height of the inner progress bar
                            decoration: BoxDecoration(
                              color: const Color(0xFF717273), // Progress bar color
                              borderRadius: BorderRadius.circular(15.0), // Rounded corners
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Show task details popup when tapped
                    showTaskDetailsPopup(context, task, index); // Call the function to show popup
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        // Bottom navigation bar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out navigation buttons
          children: <Widget>[
            const SizedBox(width: 48), // Empty space on the left
            IconButton(
              icon: Image.asset('assets/icons/target.png', height: 27, width: 27), // Icon for home page
              onPressed: () {
                Navigator.push(
                  // Navigate to HomePage when pressed
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            const Spacer(), // Spacer between icons
            IconButton(
              icon: Image.asset('assets/icons/Add Task.png', height: 29, width: 29), // Icon for adding a task
              onPressed: () {
                Navigator.push(
                  // Navigate to AddTaskPage when pressed
                  context,
                  MaterialPageRoute(builder: (context) => const AddTaskPage()),
                );
              },
            ),
            const Spacer(), // Spacer between icons
            IconButton(
              icon: Image.asset('assets/icons/search.png', height: 28, width: 28), // Icon for search page
              onPressed: () {
                Navigator.push(
                  // Navigate to SearchPage when pressed
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                );
              },
            ),
            const Spacer(), // Spacer between icons
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                'assets/icons/View Tasks.png', // Icon for current page
                height: 28,
                width: 28,
              ),
              const Text(
                  'Completed', // ข้อความใต้ไอคอน
                  style: TextStyle(
                    fontSize: 15, // ขนาดฟอนต์เล็กๆ
                    color: Colors.black, // สีของข้อความ
                  ),
                ),
              ],
            ),
            const SizedBox(width: 48), // Empty space on the right
          ],
        ),
      ),
    );
  }
}
