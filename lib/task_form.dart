import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'models/task.dart';
import 'providers/task_provider.dart';
import 'utils/date_time_utils.dart';
import 'notification_box.dart';
import 'track_goals_box.dart';
import 'color_picker.dart'; 
import 'task_title.dart';

class TaskForm extends StatefulWidget {
  final Task? initialTask; // ใช้ในการแก้ไข
  const TaskForm({super.key, this.initialTask}); // เปลี่ยน 'key' เป็นพารามิเตอร์ super

  @override
  TaskFormState createState() => TaskFormState();
}


class TaskFormState extends State<TaskForm> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;
  late bool isAllDay; 
  late Color selectedColor; 
  String? notificationOption;
  double sliderValue = 0.0; 

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTask?.title ?? '');
    descriptionController = TextEditingController(text: widget.initialTask?.description ?? '');
    isAllDay = widget.initialTask?.isAllDay ?? false;
    startDate = widget.initialTask?.startDateTime ?? DateTime.now();
    startTime = widget.initialTask?.startDateTime != null
        ? TimeOfDay.fromDateTime(widget.initialTask!.startDateTime!)
        : TimeOfDay.now();
    endDate = widget.initialTask?.endDateTime ?? DateTime.now();
    endTime = widget.initialTask?.endDateTime != null
        ? TimeOfDay.fromDateTime(widget.initialTask!.endDateTime!)
        : TimeOfDay.now();
    selectedColor = widget.initialTask?.color ?? Colors.grey;
    notificationOption = widget.initialTask?.notificationOption ?? 'None';
    sliderValue = widget.initialTask?.sliderValue ?? 0.0; // กำหนดค่าเริ่มต้นให้กับ _progress ถ้าไม่มีค่าให้เป็น 0.0
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveForm() {
    final String title = titleController.text;
    final String description = descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      final DateTime? startDateTime = startDate != null && startTime != null
          ? DateTime(
              startDate!.year,
              startDate!.month,
              startDate!.day,
              startTime!.hour,
              startTime!.minute)
          : null;

      final DateTime? endDateTime = endDate != null && endTime != null
        ? DateTime(
            endDate!.year,
            endDate!.month,
            endDate!.day,
            endTime!.hour,
            endTime!.minute)
        : null;

      if (widget.initialTask != null) {
        widget.initialTask!.title = title;
        widget.initialTask!.description = description;
        widget.initialTask!.isAllDay = isAllDay;
        widget.initialTask!.startDateTime = startDateTime;
        widget.initialTask!.endDateTime = endDateTime;
        widget.initialTask!.color = selectedColor;
        widget.initialTask!.sliderValue = sliderValue;
        widget.initialTask!.notificationOption = notificationOption ?? 'None';

        Provider.of<TaskProvider>(context, listen: false).updateTask(widget.initialTask!);
        Navigator.pop(context, widget.initialTask);
      } else {
        final String id = UniqueKey().toString();

        final Task newTask = Task(
          id: id,
          title: title,
          description: description,
          isAllDay: isAllDay,
          startDateTime: startDateTime,
          endDateTime: endDateTime,
          notificationOption: notificationOption ?? 'None',
          color: selectedColor,
          sliderValue: sliderValue, // บันทึกค่า sliderValue ลงไป
        );

        Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialTask != null;
    final buttonText = isEditing ? 'Update' : 'Save';

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 80.0),
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0),
              decoration: BoxDecoration(
                color: const Color(0xFFf2f2f2),
                borderRadius:
                    BorderRadius.circular(15.0),
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
                        const SizedBox(height: 10),
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
                                          backgroundColor: const Color(0xFFd0d0d0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        child: Text(
                                          startDate == null
                                              ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                                              : DateFormat('yyyy-MM-dd').format(startDate!),
                                          style: const TextStyle(fontSize: 15, color: Color(0xFF000000)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 65,
                                      height: 35,
                                      child: TextButton(
                                        onPressed: () => selectTime(context, true, (timeOfDay) {
                                          setState(() {
                                            startTime = timeOfDay;
                                          });
                                        }),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(3.0),
                                          backgroundColor: const Color(0xFFd0d0d0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        child: Text(
                                          startTime == null ? 'Time' : startTime!.format(context),
                                          style: const TextStyle(fontSize: 15, color: Color(0xFF000000)),
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
                                          backgroundColor: const Color(0xFFd0d0d0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        child: Text(
                                          endDate == null
                                              ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                                              : DateFormat('yyyy-MM-dd').format(endDate!),
                                          style: const TextStyle(fontSize: 15, color: Color(0xFF000000)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 65,
                                      height: 35,
                                      child: TextButton(
                                        onPressed: () => selectTime(context, false, (timeOfDay) {
                                          setState(() {
                                            endTime = timeOfDay;
                                          });
                                        }),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(3.0),
                                          backgroundColor: const Color(0xFFd0d0d0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        child: Text(
                                          endTime == null ? 'Time' : endTime!.format(context),
                                          style: const TextStyle(fontSize: 15, color: Color(0xFF000000)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                'Start Date',
                                style: TextStyle(fontSize: 19),
                              ),
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
                                    backgroundColor: const Color(0xFFd0d0d0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  child: Text(
                                    startDate == null
                                        ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                                        : DateFormat('yyyy-MM-dd').format(startDate!),
                                    style: const TextStyle(fontSize: 15, color: Color(0xFF000000)),
                                  ),
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
                                    backgroundColor: const Color(0xFFd0d0d0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  child: Text(
                                    endDate == null
                                        ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                                        : DateFormat('yyyy-MM-dd').format(endDate!),
                                    style: const TextStyle(fontSize: 15, color: Color(0xFF000000)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),

                  const SizedBox(height: 5), // เพิ่มระยะห่างระหว่างกล่อง

                  NotificationBox(
                    notificationOption: notificationOption, // Use notificationOption here
                    onOptionSelected: (newOption) {
                      setState(() {
                        notificationOption = newOption; // Update notificationOption
                      });
                    },
                  ),

                  const SizedBox(height: 5),

                  TrackGoals(
                    progress: sliderValue, // ส่งค่าเริ่มต้นไปยัง TrackGoals
                    onProgressUpdated: (value) {
                      setState(() {
                        sliderValue = value; // อัพเดตค่าความก้าวหน้าเมื่อมีการเปลี่ยนแปลง
                      });
                    },
                  ),

                  const SizedBox(height: 5),

                  ColorPicker(
                    selectedColor:
                        selectedColor, // ส่งสีที่เลือกไปยัง ColorPicker
                    onColorSelected: (color) {
                      setState(() {
                        selectedColor =
                            color; // อัพเดตสีที่ถูกเลือกเมื่อผู้ใช้เลือกสี
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
