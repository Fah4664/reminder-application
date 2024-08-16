import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // รับ arguments ที่ส่งมาจากหน้าอื่น
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String taskName = args['taskName'];
    final String taskDetails = args['taskDetails'];
    final String notificationTime = args['notificationTime'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showNotification(context, taskName, taskDetails, notificationTime);
          },
          child: const Text('Show Notification'),
        ),
      ),
    );
  }

  Future<void> _showNotification(BuildContext context, String taskName,
      String taskDetails, String notificationTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Reminder',
      'Task: $taskName\nDetails: $taskDetails\nNotification Time: $notificationTime',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
