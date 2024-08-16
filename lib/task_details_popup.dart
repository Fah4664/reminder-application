import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'providers/task_provider.dart';
import 'edit_task_page.dart';
import '../models/task.dart';
import 'utils/date_utils.dart';

void showTaskDetailsPopup(BuildContext context, Task task, int index) {
  Color dialogColor = task.color ?? Colors.grey; // Fallback color
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        backgroundColor: dialogColor, // ใช้สีที่รับเข้ามาจาก Task
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(
                          0xFF000000), // เปลี่ยนสีข้อความให้เหมาะสมกับพื้นหลัง
                    ),
                  ),
                  IconButton(
                    // แสดงหน้าจอการแก้ไข task หรือทำการอัปเดต task ตรงนี้
                    icon: SvgPicture.asset('assets/icons/pencil.svg'),
                    onPressed: () {
                      Navigator.of(context).pop(); // ปิด Dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTaskPage(task: task),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                task.description,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(
                      0xFF000000), // เปลี่ยนสีข้อความให้เหมาะสมกับพื้นหลัง
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 200,
                height: 15,
                decoration: BoxDecoration(
                  color: const Color(0xFFd0d0d0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 100) *
                        (task.sliderValue * 100 / 150),
                    height: 15,
                    decoration: BoxDecoration(
                      color: const Color(0xFF717273),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                formatDateRange(task.startDateTime, task.endDateTime),
                style: const TextStyle(
                    fontSize: 16,
                    color: Color(
                        0xFF000000)), // เปลี่ยนสีข้อความให้เหมาะสมกับพื้นหลัง
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Color(0xFF000000)), // เปลี่ยนสีไอคอน
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Provider.of<TaskProvider>(context, listen: false)
                      .markTaskAsCompleted(task);
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF000000), // สีข้อความของปุ่ม
                  backgroundColor: const Color(0xFFd0d0d0), // สีพื้นหลังของปุ่ม
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(5.0), // ความโค้งของมุมปุ่ม
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 0.5),
                ),
                child: const Text('Mark as Completed'),
              ),
              const Spacer(),
              IconButton(
                icon: SvgPicture.asset('assets/icons/trash-xmark.svg'),
                onPressed: () {
                  Provider.of<TaskProvider>(context, listen: false)
                      .removeTask(task);
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        ],
      );
    },
  );
}
