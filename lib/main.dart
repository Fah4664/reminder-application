import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'pages/splash_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
//import 'notification_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // Import Firebase options generated by FlutterFire CLI // ดึงข้อมูล firebase_options ที่สร้างอัตโนมัติจากไฟล์ `flutterfire` CLI

// Entry point of the Flutter application
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter is initialized before running the app // เรียกใช้ ensureInitialized ก่อน initializeApp
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Initialize Firebase with platform-specific options
  );
  runApp(
      const ReminderApp()); // Run the ReminderApp widget  // ใช้ const กับ constructor
}

// The main widget for the reminder application
class ReminderApp extends StatelessWidget {
  const ReminderApp(
      {super.key}); // Constructor for ReminderApp // ใช้ super.key เพื่อส่งคีย์ไปยัง superclass

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          TaskProvider(), // Provide TaskProvider to the widget tree
      child: MaterialApp(
        title: 'Reminder App', // Title of the app
        theme: ThemeData(
          primarySwatch: Colors.blue, // Set the primary color of the app
        ),
        home: AuthGate(), // Set AuthGate as the initial home screen
      ),
    );
  }
}

// AuthGate widget to determine which screen to show based on authentication status
class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance
          .authStateChanges(), // Listen for authentication state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // If the user is logged in // ผู้ใช้ล็อกอินอยู่แล้ว
            return HomePage(); // Navigate to the HomePage
          } else {
            // If the user is not logged in // ผู้ใช้ยังไม่ได้ล็อกอิน
            return LoginPage(); // Navigate to the LoginPage
          }
        }
        // While waiting for Firebase to respond, show the SplashPage // ขณะรอข้อมูลจาก Firebase
        return SplashPage(); // Display SplashPage while waiting for authentication data
      },
    );
  }
}
