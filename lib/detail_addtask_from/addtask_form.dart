import 'package:flutter/material.dart';
import '../models/task.dart';
import 'notification_box.dart';
import 'track_goals_box.dart';
import 'color_picker.dart';
import 'task_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/color_utils.dart';
import 'date_time_selector.dart';

class TaskForm extends StatefulWidget {
  final Task? initialTask;
  const TaskForm({super.key, this.initialTask});

  @override
  TaskFormState createState() => TaskFormState();
}

class TaskFormState extends State<TaskForm> {
  late TextEditingController
      titleController; // Controller for the task title input
  late TextEditingController
      descriptionController; // Controller for the task description input
  DateTime? startDate; // Variable to hold the start date of the task
  TimeOfDay? startTime; // Variable to hold the start time of the task
  DateTime? endDate; // Variable to hold the end date of the task
  TimeOfDay? endTime; // Variable to hold the end time of the task
  late bool isAllDay; // Flag to determine if the task is an all-day event
  late Color selectedColor; // Variable to store the selected color for the task
  String?
      notificationOption; // Variable to store the selected notification option
  double sliderValue =
      0.0; // Variable to hold the value of a slider (e.g., progress)

  @override
  void initState() {
    super.initState();
    // Initialize the title controller with the existing task title or an empty string
    titleController =
        TextEditingController(text: widget.initialTask?.title ?? '');
    // Initialize the description controller with the existing task description or an empty string
    descriptionController =
        TextEditingController(text: widget.initialTask?.description ?? '');
    // Set whether the task is an all-day event, defaulting to false if no existing task
    isAllDay = widget.initialTask?.isAllDay ?? false;
    // Set the start date, defaulting to the current date if no existing task
    startDate = widget.initialTask?.startDateTime ?? DateTime.now();
    // Set the start time, converting the existing DateTime to TimeOfDay if available
    startTime = widget.initialTask?.startDateTime != null
        ? TimeOfDay.fromDateTime(widget.initialTask!.startDateTime!)
        : TimeOfDay.now();
    // Set the end date, defaulting to the current date if no existing task
    endDate = widget.initialTask?.endDateTime ?? DateTime.now();
    // Set the end time, converting the existing DateTime to TimeOfDay if available
    endTime = widget.initialTask?.endDateTime != null
        ? TimeOfDay.fromDateTime(widget.initialTask!.endDateTime!)
        : TimeOfDay.now();
    // Set the selected color, converting the existing color string to Color if available
    selectedColor = widget.initialTask?.color != null
        ? colorFromString(widget.initialTask!
            .color!) // Convert String to Color // แปลง String เป็น Color
        : Colors.grey;
    // Set the notification option, defaulting to 'None' if not specified
    notificationOption = widget.initialTask?.notificationOption ?? 'None';
    // Set the slider value, defaulting to 0.0 if not specified
    sliderValue = widget.initialTask?.sliderValue ??
        0.0; // Initialize slider value  // กำหนดค่าเริ่มต้นให้กับ sliderValue ถ้าไม่มีค่าให้เป็น 0.0
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveForm() async {
    // Retrieve title and description from the text controllers.
    final String title = titleController.text;
    final String description = descriptionController.text;

    // Check if the title is not empty.
    if (title.isNotEmpty) {
      // Create DateTime objects for start and end date and time.
      final DateTime? startDateTime = startDate != null && startTime != null
          ? DateTime(startDate!.year, startDate!.month, startDate!.day,
              startTime!.hour, startTime!.minute)
          : null;
      final DateTime? endDateTime = endDate != null && endTime != null
          ? DateTime(endDate!.year, endDate!.month, endDate!.day, endTime!.hour,
              endTime!.minute)
          : null;
      // Convert selected color to a hex string for storage.
      final colorString = selectedColor.value
          .toRadixString(16)
          .padLeft(8, '0'); // แปลง Color เป็น String

      // Get the currently logged-in user. // รับ uid จากผู้ใช้ที่ล็อกอิน
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('Error: User not logged in');
        return;
      }
      final String uid = user.uid;
      if (widget.initialTask != null) {
        // If editing an existing task, update the task in Firestore.
        // Update existing task
        final taskRef = FirebaseFirestore.instance
            .collection('userTasks')
            .doc(uid) // ใช้ uid เป็นส่วนหนึ่งของคอลเลคชัน
            .collection('tasksID')
            .doc(widget.initialTask!.id);
        await taskRef.update({
          'title': title,
          'description': description,
          'isAllDay': isAllDay,
          'startDateTime': startDateTime?.toIso8601String(),
          'endDateTime': endDateTime?.toIso8601String(),
          'color': colorString,
          'sliderValue': sliderValue,
          'notificationOption': notificationOption ?? 'None',
        });

        // Navigate back to the previous screen with the updated task.
        Navigator.pop(context, widget.initialTask);
      } else {
        // Add new task
        final taskRef = FirebaseFirestore.instance
            .collection('userTasks')
            .doc(uid) // ใช้ uid เป็นส่วนหนึ่งของคอลเลคชัน
            .collection('tasksID')
            .doc(); // สร้างเอกสารใหม่ใน userTasks collection
        final newTask = Task(
          id: taskRef.id,
          title: title,
          description: description,
          isAllDay: isAllDay,
          startDateTime: startDateTime,
          endDateTime: endDateTime,
          notificationOption: notificationOption ?? 'None',
          color: colorString,
          sliderValue: sliderValue,
        );
        // Save the new task data to Firestore.
        await taskRef.set(newTask.toMap()); // บันทึกข้อมูลลงใน Firestore
        // Navigate back to the previous screen.
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if we are editing an existing task
    final isEditing = widget.initialTask != null;
    // Determine the button text based on whether we are editing or saving a new task
    final buttonText = isEditing ? 'Update' : 'Save';

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                  // Row containing buttons for Cancel, title, and Save/Update
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Cancel button to pop the current page
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
                      // Save/Update button to save the task
                      TextButton(
                        onPressed: saveForm,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF717273),
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          backgroundColor: Colors.transparent,
                        ),
                        child: Text(
                          buttonText,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Container for task title and description input fields
                  Container(
                    padding: const EdgeInsets.only(
                        top: 1.0, bottom: 1.0, left: 15.0, right: 15.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFffffff),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        TaskTitle(
                          titleController: titleController,
                          descriptionController: descriptionController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Container for date and time selection
                  DateTimeSelector(
                    startDate: startDate,
                    startTime: startTime,
                    endDate: endDate,
                    endTime: endTime,
                    isAllDay: isAllDay,
                    onStartDateChanged: (newDate) {
                      setState(() {
                        startDate = newDate;
                      });
                    },
                    onStartTimeChanged: (newTime) {
                      setState(() {
                        startTime = newTime;
                      });
                    },
                    onEndDateChanged: (newDate) {
                      setState(() {
                        endDate = newDate;
                      });
                    },
                    onEndTimeChanged: (newTime) {
                      setState(() {
                        endTime = newTime;
                      });
                    },
                    onAllDayToggle: (newValue) {
                      setState(() {
                        isAllDay = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 5), // เพิ่มระยะห่างระหว่างกล่อง
                  // Notification and Track Goals section
                  NotificationBox(
                    notificationOption:
                        notificationOption, // Use notificationOption here
                    onOptionSelected: (newOption) {
                      setState(() {
                        notificationOption =
                            newOption; // Update notificationOption
                      });
                    },
                  ),
                  const SizedBox(height: 5),
                  TrackGoals(
                    progress: sliderValue, // ส่งค่าเริ่มต้นไปยัง TrackGoals
                    onProgressUpdated: (value) {
                      setState(() {
                        sliderValue =
                            value; // อัพเดตค่าความก้าวหน้าเมื่อมีการเปลี่ยนแปลง
                      });
                    },
                  ),
                  const SizedBox(height: 5),
                  // Color Picker section
                  ColorPicker(
                    selectedColor:
                        selectedColor, // Color Picker section // ส่งสีที่เลือกไปยัง ColorPicker
                    onColorSelected: (color) {
                      setState(() {
                        selectedColor =
                            color; // Update selected color // อัพเดตสีที่ถูกเลือกเมื่อผู้ใช้เลือกสี
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
