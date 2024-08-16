import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'splash_page.dart'; // เพิ่มการ import หน้าจอ SplashPage
//import 'notification_page.dart'; // เพิ่มการ import หน้าจอ NotificationPage

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
        //routes: {
          //'/notification': (context) => const NotificationPage(),
        //},
      ),
    );
  }
}

class PopupButton extends StatelessWidget {
  const PopupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showPopup(context),
      child: const Text('Show Popup'),
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Popup Title'),
          content: const Text('This is a sample popup message.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
