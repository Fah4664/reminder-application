import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'edit_task_page.dart';
import '../models/task.dart';

void showTaskDetailsDialog(BuildContext context, Task task, int index) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8, // ปรับขนาดให้เหมาะสม
          height: MediaQuery.of(context).size.height * 0.3, // ปรับขนาดให้เหมาะสม
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                task.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
              // ปุ่มที่อยู่ทางซ้าย
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  },
                child: const Text('Close'),
              ),
              const Spacer(), // เพิ่มช่องว่างระหว่างปุ่ม
              // ปุ่มที่อยู่ตรงกลาง
              TextButton(
                onPressed: () {
                  Provider.of<TaskProvider>(context, listen: false)
                      .markTaskAsCompleted(task);
                  Navigator.of(context).pop();
                },
                child: const Text('Mark as Completed'),
              ),
              const Spacer(), // เพิ่มช่องว่างระหว่างปุ่ม
              // ปุ่มที่อยู่ทางขวา
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
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  Provider.of<TaskProvider>(context, listen: false)
                      .removeTask(task);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],


      );
    },
  );
}
