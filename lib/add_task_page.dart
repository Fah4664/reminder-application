import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'models/task.dart';
import 'providers/task_provider.dart';
import 'utils/date_time_utils.dart';
import 'notification_box.dart'; // นำเข้าฟังก์ชัน NotificationBox
import 'track_goals_box.dart'; // นำเข้า TrackGoals
import 'color_picker.dart'; // นำเข้า ColorPicker

class AddTaskPage extends StatefulWidget {
  final Task? taskToEdit; // ใช้ในการแก้ไข
  const AddTaskPage({super.key, this.taskToEdit});
  

  @override
  AddTaskPageState createState() => AddTaskPageState();
}

class AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController titleController =
    TextEditingController(); // ควบคุมข้อมูลของฟิลด์ชื่องาน
  final TextEditingController descriptionController =
    TextEditingController(); // ควบคุมข้อมูลของฟิลด์คำอธิบายงาน
    bool isAllDay = false; // สถานะการทำงานทั้งวัน
    DateTime? startDate; // วันที่เริ่มต้นของงาน
    TimeOfDay? startTime; // เวลาที่เริ่มต้นของงาน
    DateTime? endDate; // วันที่สิ้นสุดของงาน
    TimeOfDay? endTime; // เวลาที่สิ้นสุดของงาน
    String? notificationOption; // ประกาศตัวแปร notificationOption ที่เก็บค่าตัวเลือกการแจ้งเตือน
    Color? selectedColor; // เพิ่มตัวแปรสำหรับเก็บสีที่เลือก
    double _goalProgress = 0.0; // Initialize _goalProgress

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      titleController.text = widget.taskToEdit!.title;
      descriptionController.text = widget.taskToEdit!.description;
      isAllDay = widget.taskToEdit!.isAllDay;
      startDate = widget.taskToEdit!.startDateTime;
      startTime = widget.taskToEdit!.startDateTime != null ? TimeOfDay.fromDateTime(widget.taskToEdit!.startDateTime!) : null;
      endDate = widget.taskToEdit!.endDateTime;
      endTime = widget.taskToEdit!.endDateTime != null ? TimeOfDay.fromDateTime(widget.taskToEdit!.endDateTime!) : null;
      selectedColor = widget.taskToEdit!.color;
      _goalProgress = widget.taskToEdit!.goalProgress;
    } else {
      final now = DateTime.now();
      startDate = now;
      endDate = now;
    }
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
                        'New Task',
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
                            final Task newTask = Task(
                              title: title, // หัวข้อของงาน
                              description: description, // รายละเอียดของงาน
                              isAllDay: isAllDay, // เป็นงานที่ใช้เวลาทั้งวันหรือไม่
                              startDateTime: startDateTime, // วันที่เริ่มต้นของงาน
                              endDateTime: endDateTime, // วันที่สิ้นสุดของงาน
                              color: selectedColor, // สีที่เลือกสำหรับงาน
                              goalProgress: _goalProgress, // เป้าหมายความคืบหน้าของงาน
                            );

                            // เพิ่ม Task ใหม่ลงใน TaskProvider
                            Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
                            // ปิดหน้าจอการสร้างงานใหม่
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
                          'Save',
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
                                          style: const TextStyle(fontSize: 16, color: Color(0xFF000000)),
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
                                          backgroundColor: const Color(0xFFd0d0d0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        child: Text(
                                          startTime == null ? 'Time' : startTime!.format(context),
                                          style: const TextStyle(fontSize: 16, color: Color(0xFF000000)),
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
                                          style: const TextStyle(fontSize: 16, color: Color(0xFF000000)),
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
                                          backgroundColor: const Color(0xFFd0d0d0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        child: Text(
                                          endTime == null ? 'Time' : endTime!.format(context),
                                          style: const TextStyle(fontSize: 16, color: Color(0xFF000000)),
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
                                    style: const TextStyle(fontSize: 16, color: Color(0xFF000000)),
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
                                    style: const TextStyle(fontSize: 16, color: Color(0xFF000000)),
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
                    //NotificationBox
                    selectedOption: notificationOption,
                    onOptionSelected: (option) {
                      setState(() {
                        notificationOption = option;
                      });
                    },
                  ),

                  const SizedBox(height: 5),

                  TrackGoals(
                    progress: _goalProgress, // ส่งค่าเริ่มต้นไปยัง TrackGoals
                    onProgressChanged: (value) {
                      setState(() {
                        _goalProgress = value; // อัพเดตค่าความก้าวหน้าเมื่อมีการเปลี่ยนแปลง
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
