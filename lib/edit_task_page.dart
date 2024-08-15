import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'models/task.dart';
import 'providers/task_provider.dart';
//import 'utils/date_time_utils.dart';
import 'notification_box.dart';
import 'track_goals_box.dart';
import 'color_picker.dart';

class EditTaskPage extends StatefulWidget {
  final Task task; // ข้อมูลงานที่ต้องการแก้ไข
  final int index; // ดัชนีของงานในรายการ

  const EditTaskPage({super.key, required this.task, required this.index});

  @override
  EditTaskPageState createState() => EditTaskPageState();
}

class EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  bool isAllDay = false;
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;
  String? notificationOption;
  Color? selectedColor;
  double goalProgress = 0.0;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(text: widget.task.description);
    isAllDay = widget.task.isAllDay;
    startDate = widget.task.startDateTime;
    startTime = widget.task.startDateTime != null ? TimeOfDay.fromDateTime(widget.task.startDateTime!) : null;
    endDate = widget.task.endDateTime;
    endTime = widget.task.endDateTime != null ? TimeOfDay.fromDateTime(widget.task.endDateTime!) : null;
    selectedColor = widget.task.color;
    goalProgress = widget.task.goalProgress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // สีพื้นหลังของหน้าจอ
      body: Center(
        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 80.0), // การเว้นขอบด้านข้างและด้านบน-ล่าง
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0), // การเว้นขอบภายในของคอนเทนเนอร์
              decoration: BoxDecoration(
                color: const Color(0xFFf2f2f2), // สีพื้นหลังของคอนเทนเนอร์
                borderRadius:
                    BorderRadius.circular(15.0), // มุมโค้งมนของคอนเทนเนอร์
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // สีเงาของกล่อง
                    spreadRadius: 5, // การกระจายของเงา
                    blurRadius: 7, // การเบลอของเงา
                    offset: const Offset(0, 3), // ตำแหน่งของเงา
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
                          Navigator.pop(context); // ปิดหน้าจอปัจจุบัน
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
                        'Edit Task',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // ดึงค่าจาก TextField
                          final String title = titleController.text;
                          final String description = descriptionController.text;

                          // ตรวจสอบว่าค่าที่กรอกมาไม่เป็นค่าว่าง
                          if (title.isNotEmpty && description.isNotEmpty) {
                            
                            // สร้างค่า DateTime สำหรับวันที่เริ่มต้น ถ้าวันที่และเวลาที่เริ่มต้นไม่เป็น null
                            final DateTime? startDateTime = startDate != null && startTime != null
                                ? DateTime(
                                    startDate!.year,
                                    startDate!.month,
                                    startDate!.day,
                                    startTime!.hour,
                                    startTime!.minute)
                                : null;

                            // สร้างค่า DateTime สำหรับวันที่สิ้นสุด ถ้าวันที่และเวลาที่สิ้นสุดไม่เป็น null
                            final DateTime? endDateTime = endDate != null && endTime != null
                                ? DateTime(
                                    endDate!.year,
                                    endDate!.month,
                                    endDate!.day,
                                    endTime!.hour,
                                    endTime!.minute)
                                : null;

                            // Debugging lines เพื่อแสดงค่า startDateTime และ endDateTime ใน console
                            final logger = Logger();
                            // ตัวอย่างการใช้ logger
                            logger.d('Debug message: Start DateTime: $startDateTime');
                            logger.d('Debug message: End DateTime: $endDateTime');

                            // สร้างวัตถุ Task ใหม่
                            final Task updatedTask = Task(
                              title: title, // หัวข้อของงาน
                              description: description, // รายละเอียดของงาน
                              isAllDay: isAllDay, // เป็นงานที่ใช้เวลาทั้งวันหรือไม่
                              startDateTime: startDateTime, // วันที่เริ่มต้นของงาน
                              endDateTime: endDateTime, // วันที่สิ้นสุดของงาน
                              color: selectedColor, // สีที่เลือกสำหรับงาน
                              goalProgress: goalProgress, // เป้าหมายความคืบหน้าของงาน
                            );

                            // อัพเดต Task ใน TaskProvider
                            Provider.of<TaskProvider>(context, listen: false).updateTask(widget.index, updatedTask);
                            // ปิดหน้าจอการแก้ไขงาน
                            Navigator.pop(context);
                          }
                        },
                        // กำหนดสไตล์ของปุ่ม TextButton
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF717273),
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          backgroundColor: Colors.transparent,
                        ),
                        // ข้อความที่แสดงบนปุ่ม
                        child: const Text(
                          'Update',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 1.0, bottom: 1.0, left: 15.0, right: 15.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFffffff),
                      borderRadius: BorderRadius.circular(15.0),
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
                            const SizedBox(width: 10),
                            Switch(
                              value: isAllDay,
                              onChanged: (value) {
                                setState(() {
                                  isAllDay = value;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        isAllDay
                            ? Container()
                            : Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(0),
                                      title: Text(startDate == null
                                          ? 'Start Date'
                                          : DateFormat('yMMMd').format(startDate!)),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.calendar_today),
                                        onPressed: () async {
                                          DateTime? selectedDate = await showDatePicker(
                                            context: context,
                                            initialDate: startDate ?? DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2101),
                                          );
                                          if (selectedDate != null) {
                                            setState(() {
                                              startDate = selectedDate;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(0),
                                      title: Text(startTime == null
                                          ? 'Start Time'
                                          : startTime!.format(context)),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.access_time),
                                        onPressed: () async {
                                          TimeOfDay? selectedTime = await showTimePicker(
                                            context: context,
                                            initialTime: startTime ?? TimeOfDay.now(),
                                          );
                                          if (selectedTime != null) {
                                            setState(() {
                                              startTime = selectedTime;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 10),
                        isAllDay
                            ? Container()
                            : Row(
                                children: <Widget>[
                                  Expanded(
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(0),
                                      title: Text(endDate == null
                                          ? 'End Date'
                                          : DateFormat('yMMMd').format(endDate!)),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.calendar_today),
                                        onPressed: () async {
                                          DateTime? selectedDate = await showDatePicker(
                                            context: context,
                                            initialDate: endDate ?? DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2101),
                                          );
                                          if (selectedDate != null) {
                                            setState(() {
                                              endDate = selectedDate;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(0),
                                      title: Text(endTime == null
                                          ? 'End Time'
                                          : endTime!.format(context)),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.access_time),
                                        onPressed: () async {
                                          TimeOfDay? selectedTime = await showTimePicker(
                                            context: context,
                                            initialTime: endTime ?? TimeOfDay.now(),
                                          );
                                          if (selectedTime != null) {
                                            setState(() {
                                              endTime = selectedTime;
                                            });
                                          }
                                        },
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
                              'Notification',
                              style: TextStyle(fontSize: 19),
                            ),
                            NotificationBox(
                              selectedOption: notificationOption,
                              onOptionSelected: (String option) {
                                setState(() {
                                  notificationOption = option;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Track Goal',
                              style: TextStyle(fontSize: 19),
                            ),
                            TrackGoals(
                              progress: goalProgress,
                              onProgressChanged: (double progress) {
                                setState(() {
                                  goalProgress = progress;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            const Text(
                              'Color',
                              style: TextStyle(fontSize: 19),
                            ),
                            const Spacer(),
                            ColorPicker(
                              selectedColor: selectedColor,
                              onColorSelected: (Color color) {
                                setState(() {
                                  selectedColor = color;
                                });
                              },
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
