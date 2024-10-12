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
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 80.0),
            child: Center(
              child: Container(
                width: 300,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF9b9a8),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search Tasks...',
                            border: InputBorder.none,
                            fillColor: Colors.transparent,
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.search,
                        color: const Color(0xFF000000),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                final results = taskProvider.tasks.where((task) {
                  return task.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                      task.description.toLowerCase().contains(searchQuery.toLowerCase());
                }).toList();

                return results.isEmpty
                    ? const Center(
                        child: Text(
                          'No tasks found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final task = results[index];
                          return Card(
                            elevation: 4,
                            color: task.color != null
                                ? colorFromString(task.color!) // Set card color based on task
                                : const Color(0xFFede3e3),
                            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Display task title
                                  Text(
                                    task.title,
                                    style: const TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  // Display task date range
                                  Text(
                                    formatDateRange(task.startDateTime, task.endDateTime),
                                    style: const TextStyle(
                                        fontSize: 16, color: Color(0xFF000000)),
                                  ),
                                  const SizedBox(height: 5),
                                  // Task progress bar
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
                                        // Progress bar width based on sliderValue
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
                  MaterialPageRoute(builder: (context) => const AddTaskPage()),
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
                // Stay on this page, do nothing
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
                  MaterialPageRoute(builder: (context) => const ViewTasksPage()),
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
