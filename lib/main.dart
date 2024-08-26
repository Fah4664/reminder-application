import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'pages/splash_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
//import 'notification_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // ดึงข้อมูล firebase_options ที่สร้างอัตโนมัติจากไฟล์ `flutterfire` CLI

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
        home: AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // ผู้ใช้ล็อกอินอยู่แล้ว
            return HomePage();
          } else {
            // ผู้ใช้ยังไม่ได้ล็อกอิน
            return LoginPage();
          }
        }
        // ขณะรอข้อมูลจาก Firebase
        return SplashPage(); // แสดงหน้า SplashPage ขณะรอข้อมูลจาก Firebase
      },
    );
  }
}