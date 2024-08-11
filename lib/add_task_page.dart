import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'models/task.dart';
import 'providers/task_provider.dart';
import 'utils/date_time_utils.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  AddTaskPageState createState() => AddTaskPageState();
}

class AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isAllDay = false;
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    startDate = now;
    endDate = now;
  }

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
                        final DateTime? startDateTime = startDate != null && startTime != null
                            ? DateTime(startDate!.year, startDate!.month, startDate!.day, startTime!.hour, startTime!.minute)
                            : null;

                        final DateTime? endDateTime = endDate != null && endTime != null
                            ? DateTime(endDate!.year, endDate!.month, endDate!.day, endTime!.hour, endTime!.minute)
                            : null;

                        final Task newTask = Task(
                          title: title,
                          description: description,
                          isAllDay: isAllDay,
                          startDateTime: startDateTime,
                          endDateTime: endDateTime,
                        );

                        Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
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
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'Task Name...',
                        hintStyle: TextStyle(
                          fontSize: 23,
                          color: Color(0xFFd0d0d0),
                        ),
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Divider(
                      color: Color(0xFFd0d0d0),
                      thickness: 1,
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Task Description...',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFd0d0d0),
                        ),
                        contentPadding: EdgeInsets.zero,
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
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'All Day',
                          style: TextStyle(fontSize: 19),
                        ),
                        const SizedBox(width: 50),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isAllDay = !isAllDay;
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
                                    width: 29,
                                    height: 29,
                                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFffffff),
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    if (!isAllDay) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Start Date',
                            style: TextStyle(fontSize: 19),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                SizedBox(
                                  width: 100,
                                  height: 35,
                                  child: TextButton(
                                    onPressed: () => selectDate(context, true, (dateTime) {
                                      setState(() {
                                        startDate = dateTime;
                                      });
                                    }),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(3.0),
                                      backgroundColor: const Color(0xFFe0e0e0),
                                    ),
                                    child: Text(
                                      startDate == null
                                          ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                                          : DateFormat('yyyy-MM-dd').format(startDate!),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 60,
                                  height: 35,
                                  child: TextButton(
                                    onPressed: () => selectTime(context, true, (timeOfDay) {
                                      setState(() {
                                        startTime = timeOfDay;
                                      });
                                    }),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(3.0),
                                      backgroundColor: const Color(0xFFe0e0e0),
                                    ),
                                    child: Text(
                                      startTime == null
                                          ? 'Time'
                                          : startTime!.format(context),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'End Date',
                            style: TextStyle(fontSize: 19),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                SizedBox(
                                  width: 100,
                                  height: 35,
                                  child: TextButton(
                                    onPressed: () => selectDate(context, false, (dateTime) {
                                      setState(() {
                                        endDate = dateTime;
                                      });
                                    }),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(3.0),
                                      backgroundColor: const Color(0xFFe0e0e0),
                                    ),
                                    child: Text(
                                      endDate == null
                                          ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                                          : DateFormat('yyyy-MM-dd').format(endDate!),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 60,
                                  height: 35,
                                  child: TextButton(
                                    onPressed: () => selectTime(context, false, (timeOfDay) {
                                      setState(() {
                                        endTime = timeOfDay;
                                      });
                                    }),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(3.0),
                                      backgroundColor: const Color(0xFFe0e0e0),
                                    ),
                                    child: Text(
                                      endTime == null
                                          ? 'Time'
                                          : endTime!.format(context),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
