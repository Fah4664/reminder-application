import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_application/task_details_popup.dart';
import '../../providers/task_provider.dart';
import '../utils/date_utils.dart';
import '../utils/color_utils.dart';
import 'home_page.dart';
import 'add_task_page.dart';
import 'view_task_page.dart';

class SearchPage extends StatefulWidget {
  // Constructor for SearchPage.
  const SearchPage({super.key});

  @override
  // Create the state for SearchPage.
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  // Controller for the search input.
  final TextEditingController _searchController = TextEditingController();
  // Variable to store the current search query.
  String searchQuery = '';

  @override
  void initState() {
    super.initState(); // Call the superclass's initState method.
    _searchController.addListener(() {
      // Listen for changes in the search input.
      setState(() {
        // Trigger a rebuild when the search query changes.
        searchQuery = _searchController.text; // Update the search query.
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose of the controller to free up resources.
    super.dispose(); // Call the superclass's dispose method.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold widget for the basic structure.
      body: Column(
        // Main body as a column.
        children: [
          Container(
            padding: const EdgeInsets.only(top: 80.0),
            child: Center(
              child: Container(
                width: 300,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFDAE0E3),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Center align the contents
                    children: [
                      Expanded(
                        child: TextField(
                          // TextField for user input
                          controller: _searchController, // Link the controller to the TextField
                          decoration: const InputDecoration(
                            hintText: 'Search Tasks...', // Placeholder text
                            border: InputBorder.none, // No border
                            fillColor: Colors.transparent,
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5), // Space between TextField and icon
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
          const SizedBox(height: 10), // Space between the search box and the results
          Expanded(
            child: Consumer<TaskProvider>(
              // Listen to changes in TaskProvider
              builder: (context, taskProvider, child) {
                final results = taskProvider.tasks.where((task) {
                  // Filter tasks based on the search query
                  return task.title
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) || task.description
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
                              ? colorFromString(task.color!) // Set card color based on task
                              : const Color(0xFFede3e3), // Default color
                            margin: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 20), // Margin around the card
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                                children: [
                                  // Display task title
                                  Text(
                                    task.title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height:5), // Space between title and date
                                  // Display task date range
                                  Text(
                                    formatDateRange(
                                      task.startDateTime, task.endDateTime),
                                    style: const TextStyle(
                                      fontSize: 16, color: Color(0xFF000000)),
                                  ),
                                  const SizedBox(height:5), // Space between date and progress bar
                                  // Task progress bar
                                  Container(
                                    width: 200, // Width of the progress bar
                                    height: 15, // Height of the progress bar
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFd0d0d0), // Background color of the progress bar
                                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft, // Align progress to the left
                                      child: Container(
                                        // Progress bar width based on sliderValue
                                        width: (MediaQuery.of(context).size.width - 100) * (task.sliderValue * 100 / 150), // Calculate progress width
                                        height: 15,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF717273), // Progress color
                                          borderRadius: BorderRadius.circular(15.0), // Rounded corners
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
            MainAxisAlignment.spaceBetween, 
          children: <Widget>[
            const SizedBox(width: 48), 
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
                  MaterialPageRoute(builder: (context) => const AddTaskPage()),
                );
              },
            ),
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/search.png',
                  height: 28,
                  width: 28,
                ),
                const Text(
                  'Search',
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
                'assets/icons/View Tasks.png',
                height: 28,
                width: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewTasksPage()), // Navigate to ViewTasksPage
                );
              },
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}
