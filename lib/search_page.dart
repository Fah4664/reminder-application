import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'add_task_page.dart';
import 'view_task_page.dart';
import 'home_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final results = taskProvider.tasks.where((task) {
            return task.title
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) ||
                task.description
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase());
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
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      onTap: () {
                        Navigator.pop(
                            context, task); // ส่งข้อมูลกลับไปยังหน้า HomePage
                      },
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
