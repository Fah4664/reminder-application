import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'models/task.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;
  final int index; // เพิ่มพารามิเตอร์ดัชนี

  const EditTaskPage(
      {super.key,
      required this.task,
      required this.index}); // อัปเดตคอนสตรัคเตอร์

  @override
  // ignore: library_private_types_in_public_api
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Edit Task')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิดหน้า
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<TaskProvider>(context, listen: false)
                        .updateTask(
                      widget.index, // ส่งดัชนีที่นี่
                      widget.task.copyWith(
                        title: _titleController.text,
                        description: _descriptionController.text,
                      ),
                    );
                    Navigator.of(context).pop(); // ปิดหน้า
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
