import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/task.dart';
import 'providers/task_provider.dart';

class AddTaskPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255), // พื้นหลังของหน้าจอจริงเป็นสีขาว
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: Color(0xFFf2f2f2), // พื้นหลังของป๊อปอัพเป็นสีเทาอ่อน
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 100, // กำหนดความกว้างของปุ่ม Cancel
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF717273), // สีตัวอักษร
                        padding: EdgeInsets.symmetric(vertical: 10.0), // ขนาดปุ่ม
                        backgroundColor: Colors.transparent, // ไม่มีพื้นหลัง
                        minimumSize: Size(100, 40), // ขนาดปุ่มขั้นต่ำ
                        side: BorderSide.none, // ไม่มีขอบ
                      ),
                      child: Text('Cancel'),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'New Task',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100, // กำหนดความกว้างของปุ่ม Save
                    child: TextButton(
                      onPressed: () {
                        final String title = titleController.text;
                        final String description = descriptionController.text;

                        if (title.isNotEmpty && description.isNotEmpty) {
                          final Task newTask = Task(
                            title: title,
                            description: description,
                          );

                          Provider.of<TaskProvider>(context, listen: false)
                              .addTask(newTask);
                          Navigator.pop(context);
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF717273), // สีตัวอักษร
                        padding: EdgeInsets.symmetric(vertical: 10.0), // ขนาดปุ่ม
                        backgroundColor: Colors.transparent, // ไม่มีพื้นหลัง
                        minimumSize: Size(100, 40), // ขนาดปุ่มขั้นต่ำ
                        side: BorderSide.none, // ไม่มีขอบ
                      ),
                      child: Text('Save'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20), // เว้นระยะห่างระหว่างแถวปุ่มกับฟิลด์ข้อความ
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Task Title'),
              ),
              SizedBox(height: 20), // เพิ่มระยะห่างระหว่าง TextField
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Task Description'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
