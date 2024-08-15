import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'edit_task_page.dart';
import '../models/task.dart';

void showTaskDetailsPopup(BuildContext context, Task task, int index) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
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
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pop(); // ปิด Dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTaskPage(
                            task: task,
                            index: index,
                          ),
                        ),
                      );
                    },
                  ),

                ],
              ),
              const SizedBox(height: 10),
              Text(
                task.description,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Provider.of<TaskProvider>(context, listen: false).markTaskAsCompleted(task);
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF000000), // กำหนดสีข้อความ
                  backgroundColor: const Color(0xFFd0d0d0), // กำหนดสีพื้นหลังของปุ่ม
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0), // กำหนดความโค้งของมุม
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.5), // กำหนดพื้นที่ภายในปุ่ม
                ),
                child: const Text('Mark as Completed'),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete, color: Color(0xFF000000)),
                onPressed: () {
                  Provider.of<TaskProvider>(context, listen: false).removeTask(task);
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