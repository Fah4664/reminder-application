import 'package:flutter/material.dart';
import 'dart:async'; // Import Dart's asynchronous library
import 'login_page.dart'; // Import the LoginPage to navigate after the splash screen

// This class represents the splash page
class SplashPage extends StatefulWidget {
  const SplashPage({super.key}); // Constructor

  @override
  // Creates the state for the splash page
  _SplashPageState createState() => _SplashPageState();
}

// State class for SplashPage
class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState(); // Call the superclass's initState method
    // Set a timer to navigate to the login page after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Check if the widget is still mounted in the widget tree // ตรวจสอบว่าผู้ใช้ยังอยู่ในต้นไม้ของ widget
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage()), // Navigate to LoginPage
          (Route<dynamic> route) =>
              false, // Remove all previous routes from the stack // ลบหน้าทั้งหมดใน stack
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Set the background color of the splash page
      body: Center(
        child: Image.asset(
          'assets/images/reminder.png', // Specify the path of the image asset  // ระบุเส้นทางไฟล์ของรูปภาพ
          width: 200, // Set the width of the image
          height: 200, // Set the height of the image
        ),
      ),
    );
  }
}
