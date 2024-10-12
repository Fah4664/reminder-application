import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_application/task_details_popup.dart';
import '../../providers/task_provider.dart';
import 'add_task_page.dart';
import 'view_task_page.dart';
import 'home_page.dart';
import '../utils/date_utils.dart';
import '../utils/color_utils.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key}); // Constructor for SearchPage

  @override
  _SearchPageState createState() =>
      _SearchPageState(); // Create the state for SearchPage
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController =
      TextEditingController(); // Controller for the search input
  String searchQuery = ''; // Variable to store the current search query

  @override
  void initState() {
    super.initState(); // Call the superclass's initState method
    _searchController.addListener(() {
      // Listen for changes in the search input
      setState(() {
        // Trigger a rebuild when the search query changes
        searchQuery = _searchController.text; // Update the search query
      });
    });
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Dispose of the controller to free up resources
    super.dispose(); // Call the superclass's dispose method
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold widget for the basic structure
      body: Column(
        // Main body as a column
        children: [
          Container(
            padding: const EdgeInsets.only(top: 80.0), // Add padding at the top
            child: Center(
              child: Container(
                width: 300, // Set the width of the search box
                height: 60, // Set the height of the search box
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 218, 224, 227), // สีเทาเป็นพื้นหลังของช่องค้นหา
                  borderRadius: BorderRadius.circular(20.0), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Horizontal padding
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center align the contents
                    children: [
                      Expanded(
                        child: TextField(
                          // TextField for user input
                          controller:
                              _searchController, // Link the controller to the TextField
                          decoration: const InputDecoration(
                            hintText: 'Search Tasks...', // Placeholder text
                            border: InputBorder.none, // No border
                            fillColor: Colors.transparent,
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: 5), // Space between TextField and icon
                      const Icon(
                        Icons.search, // Search icon
                        color: Color(0xFF000000), // Color of the icon
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
              height: 10), // Space between the search box and the results
          Expanded(
            child: Consumer<TaskProvider>(
              // Listen to changes in TaskProvider
              builder: (context, taskProvider, child) {
                final results = taskProvider.tasks.where((task) {
                  // Filter tasks based on the search query
                  return task.title
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                      task.description
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());
                }).toList();

                return results.isEmpty // Check if the results are empty
                    ? const Center(
                        child: Text(
                          'No tasks found', // Message when no tasks are found
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        // Build a list view of the filtered tasks
                        itemCount: results.length, // Number of tasks to display
                        itemBuilder: (context, index) {
                          final task = results[index]; // Get the current task
                          return Card(
                            // Card widget for each task
                            elevation: 4, // Shadow elevation
                            color: task.color != null
                                ? colorFromString(
                                    task.color!) // Set card color based on task
                                : const Color(0xFFede3e3), // Default color
                            margin: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 20), // Margin around the card
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text to the start
                                children: [
                                  // Display task title
                                  Text(
                                    task.title,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                      height:
                                          5), // Space between title and date
                                  // Display task date range
                                  Text(
                                    formatDateRange(
                                        task.startDateTime, task.endDateTime),
                                    style: const TextStyle(
                                        fontSize: 16, color: Color(0xFF000000)),
                                  ),
                                  const SizedBox(
                                      height:
                                          5), // Space between date and progress bar
                                  // Task progress bar
                                  Container(
                                    width: 200, // Width of the progress bar
                                    height: 15, // Height of the progress bar
                                    decoration: BoxDecoration(
                                      color: const Color(
                                          0xFFd0d0d0), // Background color of the progress bar
                                      borderRadius: BorderRadius.circular(
                                          15.0), // Rounded corners
                                    ),
                                    child: Align(
                                      alignment: Alignment
                                          .centerLeft, // Align progress to the left
                                      child: Container(
                                        // Progress bar width based on sliderValue
                                        width: (MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100) *
                                            (task.sliderValue *
                                                100 /
                                                150), // Calculate progress width
                                        height: 15,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                              0xFF717273), // Progress color
                                          borderRadius: BorderRadius.circular(
                                              15.0), // Rounded corners
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // Show task details popup when tapped
                                showTaskDetailsPopup(context, task, index);
                              },
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Space between icons
          children: <Widget>[
            const SizedBox(width: 48), // Empty space on the left
            IconButton(
              icon: Image.asset(
                'assets/icons/target.png', // Icon for Home
                height: 27,
                width: 27,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const HomePage()), // Navigate to HomePage
                );
              },
            ),
            const Spacer(),
            IconButton(
              icon: Image.asset(
                'assets/icons/Add Task.png', // Icon for Add Task
                height: 29,
                width: 29,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const AddTaskPage()), // Navigate to AddTaskPage
                );
              },
            ),
            const Spacer(),
            IconButton(
              icon: Image.asset(
                'assets/icons/search.png', // Icon for Search (current page)
                height: 28,
                width: 28,
              ),
              onPressed: () {
                // Stay on this page, do nothing
              },
            ),
            const Spacer(),
            IconButton(
              icon: Image.asset(
                'assets/icons/View Tasks.png', // Icon for View Tasks
                height: 28,
                width: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ViewTasksPage()), // Navigate to ViewTasksPage
                );
              },
            ),
            const SizedBox(width: 48), // Empty space on the right
          ],
        ),
      ),
    );
  }
}
