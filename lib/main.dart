import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'splash_page.dart'; // เพิ่มการ import หน้าจอ SplashPage

void main() {
  runApp(const ReminderApp()); // ใช้ const กับ constructor
}

class ReminderApp extends StatelessWidget {
  const ReminderApp({super.key}); // ใช้ super.key เพื่อส่งคีย์ไปยัง superclass

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        title: 'Reminder App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashPage(), // ใช้ const กับ SplashPage
      ),
    );
  }
}
