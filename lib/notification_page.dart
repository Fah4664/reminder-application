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
    final DateTime eventDateTime = DateTime.parse(args['eventDateTime']); // สมมติว่าเป็นรูปแบบ ISO8601

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // รับตัวเลือกการแจ้งเตือนที่เลือก
            final String selectedNotificationOption = args['notificationTime'] ?? 'None';
            // คำนวณเวลาการแจ้งเตือนตามตัวเลือกที่เลือก
            DateTime notificationDateTime = _calculateNotificationTime(eventDateTime, selectedNotificationOption);
            
            // แสดงการแจ้งเตือนเฉพาะเมื่อเวลาที่คำนวณไว้ในอนาคต
            if (notificationDateTime.isAfter(DateTime.now())) {
              _showNotification(context, taskName, taskDetails, notificationDateTime);
            } else {
              // จัดการกรณีที่เวลาการแจ้งเตือนอยู่ในอดีต
              print('เวลาการแจ้งเตือนอยู่ในอดีต');
            }
          },
          child: const Text('Show Notification'),
        ),
      ),
    );
  }

  DateTime _calculateNotificationTime(DateTime eventDateTime, String option) {
    Duration offset;
    switch (option) {
      case '5 minutes before':
        offset = Duration(minutes: 5);
        break;
      case '10 minutes before':
        offset = Duration(minutes: 10);
        break;
      case '15 minutes before':
        offset = Duration(minutes: 15);
        break;
      case '30 minutes before':
        offset = Duration(minutes: 30);
        break;
      case '1 hour before':
        offset = Duration(hours: 1);
        break;
      case '2 hours before':
        offset = Duration(hours: 2);
        break;
      case '1 day before':
        offset = Duration(days: 1);
        break;
      case '2 days before':
        offset = Duration(days: 2);
        break;
      case '1 week before':
        offset = Duration(days: 7);
        break;
      case 'At time of event':
      default:
        return eventDateTime; // ไม่มีการลบเวลา
    }
    return eventDateTime.subtract(offset);
  }

  Future<void> _showNotification(BuildContext context, String taskName,
      String taskDetails, DateTime notificationDateTime) async {
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

    // ใช้รหัสเฉพาะสำหรับแต่ละการแจ้งเตือน
    final int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(10000);

    await flutterLocalNotificationsPlugin.schedule(
      notificationId,
      'Reminder',
      'Task: $taskName\nDetails: $taskDetails',
      notificationDateTime,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
