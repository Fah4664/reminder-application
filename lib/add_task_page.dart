import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/task.dart';
import 'providers/task_provider.dart';

class AddTaskPage extends StatefulWidget {
  AddTaskPage({super.key});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isAllDay = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: const Color(0xFFf2f2f2),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF717273),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      backgroundColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const Text(
                    'New Task',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final String title = titleController.text;
                      final String description = descriptionController.text;

                      if (title.isNotEmpty && description.isNotEmpty) {
                        final Task newTask = Task(
                          title: title,
                          description: description,
                          isAllDay: isAllDay, // บันทึกสถานะ All Day
                        );

                        Provider.of<TaskProvider>(context, listen: false)
                            .addTask(newTask);
                        Navigator.pop(context);
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF717273),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      backgroundColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(top: 1.0, bottom: 1.0, left: 15.0, right: 15.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFffffff),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // TextField สำหรับ Task Name
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'Task Name...',
                        hintStyle: TextStyle(
                          fontSize: 23,
                          color: Color(0xFFd0d0d0),
                        ),
                        contentPadding: EdgeInsets.zero, // ไม่มี padding เพิ่มเติม
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                    // Divider ไม่มีระยะห่าง
                    const Divider(
                      color: Color(0xFFd0d0d0),
                      thickness: 1, // ความหนาของเส้น
                    ),
                    // TextField สำหรับ Task Description
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Task Description...',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFd0d0d0),
                        ),
                        contentPadding: EdgeInsets.zero, // ไม่มี padding เพิ่มเติม
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFffffff),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Additional Information',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'All Day',
                          style: TextStyle(fontSize: 18),
                        ),
                        Row(
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isAllDay = false;
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: !isAllDay ? Colors.grey[300] : Colors.blue,
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('No'),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isAllDay = true;
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: isAllDay ? Colors.blue : Colors.grey[300],
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
