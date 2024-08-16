import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String taskName = args['taskName'];
    final String taskDetails = args['taskDetails'];
    final DateTime eventDateTime = DateTime.parse(args['eventDateTime']);
    final String notificationOption = args['notificationTime'] ?? 'None';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _scheduleNotification(context, taskName, taskDetails,
              eventDateTime, notificationOption),
          child: const Text('Show Notification'),
        ),
      ),
    );
  }

  void _scheduleNotification(BuildContext context, String taskName,
      String taskDetails, DateTime eventDateTime, String option) {
    final DateTime notificationDateTime =
        _calculateNotificationTime(eventDateTime, option);

    if (notificationDateTime.isAfter(DateTime.now())) {
      _showNotification(taskName, taskDetails, notificationDateTime);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification time is in the past.')),
      );
    }
  }

  DateTime _calculateNotificationTime(DateTime eventDateTime, String option) {
    Duration offset;
    switch (option) {
      case '5 minutes before':
        offset = const Duration(minutes: 5);
        break;
      case '10 minutes before':
        offset = const Duration(minutes: 10);
        break;
      case '15 minutes before':
        offset = const Duration(minutes: 15);
        break;
      case '30 minutes before':
        offset = const Duration(minutes: 30);
        break;
      case '1 hour before':
        offset = const Duration(hours: 1);
        break;
      case '2 hours before':
        offset = const Duration(hours: 2);
        break;
      case '1 day before':
        offset = const Duration(days: 1);
        break;
      case '2 days before':
        offset = const Duration(days: 2);
        break;
      case '1 week before':
        offset = const Duration(days: 7);
        break;
      case 'At time of event':
      default:
        return eventDateTime;
    }
    return eventDateTime.subtract(offset);
  }

  Future<void> _showNotification(String taskName, String taskDetails,
      DateTime notificationDateTime) async {
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

    final int notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(10000);

    // ignore: deprecated_member_use
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

void main() {
  runApp(const MyApp());
  _initializeNotifications();
}

void _initializeNotifications() {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mimas/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotificationPage(),
    );
  }
}
