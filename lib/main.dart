import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'splash_page.dart'; // เพิ่มการ import หน้าจอ SplashPage
//import 'notification_page.dart'; // เพิ่มการ import หน้าจอ NotificationPage
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // เรียกใช้ ensureInitialized ก่อน initializeApp
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        //routes: {
        //'/notification': (context) => const NotificationPage(),
        //},
      ),
    );
  }
}
