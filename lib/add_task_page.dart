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
    // กำหนดค่าเริ่มต้นให้เป็นวันที่ปัจจุบัน
    final now = DateTime.now(); // วันที่และเวลาในปัจจุบัน
    startDate = now; // กำหนดวันที่เริ่มต้น
    endDate = now; // กำหนดวันที่สิ้นสุด
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // สีพื้นหลังของ Scaffold
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0), // ระยะห่างรอบ ๆ Container
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0), // ระยะห่างภายใน Container
          decoration: BoxDecoration(
            color: const Color(0xFFf2f2f2), // สีพื้นหลังของ Container
            borderRadius: BorderRadius.circular(15.0), // มุมโค้งมนของ Container
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // สีของเงา
                spreadRadius: 5, // ระยะการกระจายของเงา
                blurRadius: 7, // ความเบลอของเงา
                offset: const Offset(0, 3), // ตำแหน่งของเงา
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ขนาดของ Column
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // การจัดตำแหน่งของ Row
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // ปิดหน้า AddTaskPage
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF717273), // สีของข้อความในปุ่ม
                      padding: const EdgeInsets.symmetric(vertical: 10.0), // ระยะห่างภายในปุ่ม
                      backgroundColor: Colors.transparent, // สีพื้นหลังของปุ่ม
                    ),
                    child: const Text(
                      'Cancel', // ข้อความที่แสดงในปุ่ม
                      style: TextStyle(fontSize: 16), // ขนาดตัวอักษรของข้อความในปุ่ม
                    ),
                  ),
                  const Text(
                    'New Task', // ข้อความที่แสดงบนหน้า
                    style: TextStyle(
                      fontSize: 20, // ขนาดตัวอักษร
                      fontWeight: FontWeight.bold, // น้ำหนักของตัวอักษร
                      color: Color(0xFF000000), // สีของตัวอักษร
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final String title = titleController.text; // ข้อความจาก TextField สำหรับชื่อกิจกรรม
                      final String description = descriptionController.text; // ข้อความจาก TextField สำหรับรายละเอียดกิจกรรม

                      if (title.isNotEmpty && description.isNotEmpty) {
                        final DateTime? startDateTime = startDate != null && startTime != null
                            ? DateTime(startDate!.year, startDate!.month, startDate!.day, startTime!.hour, startTime!.minute) // วันที่และเวลาของกิจกรรมเริ่มต้น
                            : null;

                        final DateTime? endDateTime = endDate != null && endTime != null
                            ? DateTime(endDate!.year, endDate!.month, endDate!.day, endTime!.hour, endTime!.minute) // วันที่และเวลาของกิจกรรมสิ้นสุด
                            : null;

                        final Task newTask = Task(
                          title: title,
                          description: description,
                          isAllDay: isAllDay,
                          startDateTime: startDateTime,
                          endDateTime: endDateTime,
                        );

                        Provider.of<TaskProvider>(context, listen: false).addTask(newTask); // เพิ่มกิจกรรมใหม่
                        Navigator.pop(context); // ปิดหน้า AddTaskPage
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF717273), // สีของข้อความในปุ่ม
                      padding: const EdgeInsets.symmetric(vertical: 10.0), // ระยะห่างภายในปุ่ม
                      backgroundColor: Colors.transparent, // สีพื้นหลังของปุ่ม
                    ),
                    child: const Text(
                      'Save', // ข้อความที่แสดงในปุ่ม
                      style: TextStyle(fontSize: 16), // ขนาดตัวอักษรของข้อความในปุ่ม
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10), // ระยะห่างระหว่าง Widget
              Container(
                padding: const EdgeInsets.only(top: 1.0, bottom: 1.0, left: 15.0, right: 15.0), // ระยะห่างภายใน Container
                decoration: BoxDecoration(
                  color: const Color(0xFFffffff), // สีพื้นหลังของ Container
                  borderRadius: BorderRadius.circular(8.0), // มุมโค้งมนของ Container
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // การจัดตำแหน่งของ Column
                  children: <Widget>[
                    TextField(
                      controller: titleController, // Controller สำหรับ TextField นี้
                      decoration: const InputDecoration(
                        hintText: 'Task Name...', // ข้อความที่แสดงใน TextField เมื่อไม่มีข้อความ
                        hintStyle: TextStyle(
                          fontSize: 23, // ขนาดตัวอักษรของข้อความที่แสดงใน TextField
                          color: Color(0xFFd0d0d0), // สีของข้อความที่แสดงใน TextField
                        ),
                        contentPadding: EdgeInsets.zero, // ระยะห่างภายใน TextField
                        border: InputBorder.none, // ไม่มีขอบ TextField
                      ),
                      style: const TextStyle(fontSize: 18), // ขนาดตัวอักษรของข้อความใน TextField
                    ),
                    const Divider(
                      color: Color(0xFFd0d0d0), // สีของ Divider
                      thickness: 1, // ความหนาของ Divider
                    ),
                    TextField(
                      controller: descriptionController, // Controller สำหรับ TextField นี้
                      decoration: const InputDecoration(
                        hintText: 'Task Description...', // ข้อความที่แสดงใน TextField เมื่อไม่มีข้อความ
                        hintStyle: TextStyle(
                          fontSize: 18, // ขนาดตัวอักษรของข้อความที่แสดงใน TextField
                          color: Color(0xFFd0d0d0), // สีของข้อความที่แสดงใน TextField
                        ),
                        contentPadding: EdgeInsets.zero, // ระยะห่างภายใน TextField
                        border: InputBorder.none, // ไม่มีขอบ TextField
                      ),
                      style: const TextStyle(fontSize: 18), // ขนาดตัวอักษรของข้อความใน TextField
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5), // ระยะห่างระหว่าง Widget
              Container(
                padding: const EdgeInsets.all(15.0), // ระยะห่างภายใน Container
                decoration: BoxDecoration(
                  color: const Color(0xFFffffff), // สีพื้นหลังของ Container
                  borderRadius: BorderRadius.circular(10.0), // มุมโค้งมนของ Container
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // การจัดตำแหน่งของ Column
                  children: <Widget>[
                    const SizedBox(height: 1), // ระยะห่างระหว่าง Widget
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'All Day',
                          style: TextStyle(fontSize: 19),
                        ),
                        const SizedBox(width: 50), // ระยะห่างระหว่าง 'All Day' กับปุ่ม
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isAllDay = !isAllDay; // สลับสถานะของ isAllDay
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
                                    height: 29, // ปรับให้ความสูงเท่ากันกับความกว้าง
                                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFffffff), // สีพื้นหลังของ Container
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)), // มุมโค้งมนของ Container
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1), // ระยะห่างระหว่าง 'All Day' และวันที่ด้านล่าง
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
                                  width: 70,
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
                                TextButton(
                                  onPressed: () => selectTime(context, true, (timeOfDay) {
                                    setState(() {
                                      startTime = timeOfDay;
                                    });
                                  }),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(3.0),
                                    backgroundColor: const Color(0xFFe0e0e0),
                                    minimumSize: const Size(55, 35), // ปรับความสูงที่นี่
                                  ),
                                  child: Text(
                                    startTime == null
                                        ? 'Time'
                                        : startTime!.format(context),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
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
                                TextButton(
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
                                const SizedBox(width: 20),
                                TextButton(
                                  onPressed: () => selectTime(context, false, (timeOfDay) {
                                    setState(() {
                                      endTime = timeOfDay;
                                    });
                                  }),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(1.0),
                                    backgroundColor: const Color(0xFFe0e0e0),
                                  ),
                                  child: Text(
                                    endTime == null
                                        ? 'Time'
                                        : endTime!.format(context),
                                    style: const TextStyle(fontSize: 16),
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
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(1.0),
                                  backgroundColor: const Color(0xFFe0e0e0),
                                ),
                                onPressed: () => selectDate(context, true, (dateTime) {
                                  setState(() {
                                    startDate = dateTime;
                                  });
                                }),
                                child: Text(
                                  startDate == null
                                      ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                                      : DateFormat('yyyy-MM-dd').format(startDate!),
                                  style: const TextStyle(fontSize: 16),
                                ),
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
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(1.0),
                                  backgroundColor: const Color(0xFFe0e0e0),
                                ),
                                onPressed: () => selectDate(context, false, (dateTime) {
                                  setState(() {
                                    endDate = dateTime;
                                  });
                                }),
                                child: Text(
                                  endDate == null
                                      ? DateFormat('yyyy-MM-dd').format(DateTime.now())
                                      : DateFormat('yyyy-MM-dd').format(endDate!),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
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