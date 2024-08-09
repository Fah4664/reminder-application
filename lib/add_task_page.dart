import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // นำเข้าแพ็กเกจ intl
import 'models/task.dart';
import 'providers/task_provider.dart';
import 'date_time_utils.dart'; // นำเข้าฟังก์ชันจากไฟล์ date_time_utils.dart

class AddTaskPage extends StatefulWidget {
  AddTaskPage({super.key});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isAllDay = false;
  DateTime? startDateTime;
  DateTime? endDateTime;

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
                          isAllDay: isAllDay,
                          startDateTime: startDateTime,
                          endDateTime: endDateTime,
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
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFffffff),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'All Day',
                          style: TextStyle(fontSize: 19),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isAllDay = !isAllDay; // Toggle the state
                            });
                          },
                          child: Container(
                            width: 65,
                            height: 35,
                            decoration: BoxDecoration(
                              color: isAllDay ? const Color(0xFF717273) : const Color(0xFFd0d0d0),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFFFFFFF)),
                            ),
                            child: Stack(
                              children: <Widget>[
                                AnimatedAlign(
                                  duration: const Duration(milliseconds: 200),
                                  alignment: isAllDay ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                    decoration: BoxDecoration(
                                      color: isAllDay ? const Color(0xFFFFFFFF) : const Color(0xFFFFFFFF),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (!isAllDay) ...[
                      const Text(
                        'Start Date & Time',
                        style: TextStyle(fontSize: 19),
                      ),
                      TextButton(
                        onPressed: () => selectDateTime(context, true, (dateTime) {
                          if (mounted) {
                            setState(() {
                              startDateTime = dateTime;
                            });
                          }
                        }),
                        child: Text(
                          startDateTime == null
                              ? 'Select Date & Time'
                              : DateFormat('yyyy-MM-dd HH:mm').format(startDateTime!),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'End Date & Time',
                        style: TextStyle(fontSize: 19),
                      ),
                      TextButton(
                        onPressed: () => selectDateTime(context, false, (dateTime) {
                          if (mounted) {
                            setState(() {
                              endDateTime = dateTime;
                            });
                          }
                        }),
                        child: Text(
                          endDateTime == null
                              ? 'Select Date & Time'
                              : DateFormat('yyyy-MM-dd HH:mm').format(endDateTime!),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ] else ...[
                      const Text(
                        'Start Date',
                        style: TextStyle(fontSize: 19),
                      ),
                      TextButton(
                        onPressed: () => selectDate(context, true, (dateTime) {
                          if (mounted) {
                            setState(() {
                              startDateTime = dateTime;
                            });
                          }
                        }),
                        child: Text(
                          startDateTime == null
                              ? 'Select Date'
                              : DateFormat('yyyy-MM-dd').format(startDateTime!),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'End Date',
                        style: TextStyle(fontSize: 19),
                      ),
                      TextButton(
                        onPressed: () => selectDate(context, false, (dateTime) {
                          if (mounted) {
                            setState(() {
                              endDateTime = dateTime;
                            });
                          }
                        }),
                        child: Text(
                          endDateTime == null
                              ? 'Select Date'
                              : DateFormat('yyyy-MM-dd').format(endDateTime!),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
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
