import 'package:flutter/material.dart';

// Widget for NotificationBox that allows users to select notification options.
class NotificationBox extends StatefulWidget {
  final String? notificationOption; // ตัวเลือกที่เลือกแล้ว
  final Function(String)
      onOptionSelected; // ฟังก์ชันที่เรียกเมื่อมีการเลือกตัวเลือก

  const NotificationBox({
    super.key,
    this.notificationOption,
    required this.onOptionSelected,
  });

  @override
  NotificationBoxState createState() => NotificationBoxState();
}

// State for NotificationBox to manage the selected notification option.
class NotificationBoxState extends State<NotificationBox> {
  // List of options for notifications.
  // รายการตัวเลือกสำหรับการแจ้งเตือน
  final List<String> _options = [
    'None',
    'At time of event',
    '5 minutes before',
    '10 minutes before',
    '15 minutes before',
    '30 minutes before',
    '1 hour before',
    '2 hours before',
    '1 day before',
    '2 days before',
    '1 week before',
  ];

  // Variable to hold the selected option in the dialog.
  // ตัวแปรสำหรับเก็บตัวเลือกที่เลือกในป๊อปอัพ
  String? _selectedOptionInDialog;

  @override
  void initState() {
    super.initState();
    // Set the default value from widget.notificationOption or 'None'.
    // ใช้ค่าเริ่มต้นจาก widget.notificationOption หรือ 'None'
    _selectedOptionInDialog = widget.notificationOption ?? 'None';
  }

  // Function to show a popup dialog when the NotificationBox is tapped.
  // ฟังก์ชันที่แสดงป๊อปอัพเมื่อคลิกที่ NotificationBox
  void _showOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(5.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: const Color(0xFFd0d0d0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _options.map((option) {
              final isSelected = option == _selectedOptionInDialog;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.5),
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFf2f2f2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: ListTile(
                    title: Text(
                      option,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedOptionInDialog = option;
                      });
                      widget.onOptionSelected(
                          option); // Call function when an option is selected // เรียกฟังก์ชันเมื่อเลือกตัวเลือก
                      Navigator.of(context)
                          .pop(); // Close the popup // ปิดป๊อปอัพ
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build method to create the UI for NotificationBox.
    return GestureDetector(
      onTap: _showOptionsDialog, // Show dialog when tapped
      child: Container(
        padding:
            const EdgeInsets.all(15.0), // Padding inside the NotificationBox
        decoration: BoxDecoration(
          color: const Color(0xFFffffff),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _showOptionsDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(8.0),
                  border:
                      Border.all(color: const Color(0xFFd0d0d0), width: 1.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _selectedOptionInDialog ??
                          'None', // Display 'None' if value is null // ใช้ 'None' ถ้าค่าเป็น null
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFF717273).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
