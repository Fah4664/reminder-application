import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart'; 
import '../providers/task_provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
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
          icon: Icon(Icons.arrow_back),
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
            decoration: InputDecoration(
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
              ? Center(
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
    );
  }
}
