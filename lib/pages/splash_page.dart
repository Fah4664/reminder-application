import 'package:flutter/material.dart';
import 'dart:async';
import 'login_page.dart';

// This class represents the splash page.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  // Creates the state for the splash page.
  SplashPageState createState() => SplashPageState();
}

// State class for SplashPage.
class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // Call the superclass's initState method.
    super.initState();
    // Set a timer to navigate to the login page after 3 seconds.
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Check if the widget is still mounted in the widget tree.
        Navigator.pushAndRemoveUntil(
          context,
          // Navigate to LoginPage.
          MaterialPageRoute(builder: (context) => LoginPage()),
          // Remove all previous routes from the stack.
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
        Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/reminder.png',
          width: 200,
          height: 200, 
        ),
      ),
    );
  }
}
