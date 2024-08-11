import 'package:flutter/material.dart';

// คลาส NotificationBox เป็น StatefulWidget ซึ่งจะใช้สำหรับสร้างกล่องแสดงการแจ้งเตือน
class NotificationBox extends StatefulWidget {
  final String? selectedOption; // ตัวเลือกที่เลือกแล้ว
  final Function(String) onOptionSelected; // ฟังก์ชันที่เรียกเมื่อมีการเลือกตัวเลือก

  // สร้าง NotificationBox พร้อมพารามิเตอร์ต่างๆ
  const NotificationBox({
    super.key,
    this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  NotificationBoxState createState() => NotificationBoxState();
}

// สถานะของ NotificationBox
class NotificationBoxState extends State<NotificationBox> {
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

  // ตัวแปรสำหรับเก็บตัวเลือกที่เลือกในป๊อปอัพ
  String? _selectedOptionInDialog;

  @override
  void initState() {
    super.initState();
    // กำหนดค่าเริ่มต้นสำหรับตัวเลือกที่เลือกในป๊อปอัพ
    _selectedOptionInDialog = widget.selectedOption ?? 'None';
  }

  // ฟังก์ชันที่แสดงป๊อปอัพเมื่อคลิกที่ NotificationBox
  void _showOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(5.0), // การตั้งค่าระยะห่างภายในของ AlertDialog
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _options.map((option) {
              final isSelected = option == _selectedOptionInDialog;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0), // การตั้งค่าระยะห่างแนวตั้งของแต่ละตัวเลือก
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.grey[200] : Colors.transparent, // เน้นแถวที่เลือก
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: ListTile(
                    title: Text(
                      option,
                      style: const TextStyle(
                        fontSize: 14.0, // ขนาดของฟอนต์
                        color: Colors.black, // สีของข้อความ
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedOptionInDialog = option; // อัปเดตสถานะของตัวเลือกที่เลือก
                      });
                      widget.onOptionSelected(option); // เรียกฟังก์ชันเมื่อเลือกตัวเลือก
                      Navigator.of(context).pop(); // ปิดป๊อปอัพ
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
    return GestureDetector(
      onTap: _showOptionsDialog, // เรียกใช้ฟังก์ชันเมื่อคลิกที่พื้นที่นี้
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: const Color(0xFFffffff), // สีพื้นหลังของกล่อง
          borderRadius: BorderRadius.circular(15.0), // ความโค้งของมุมกล่อง
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 18), // ขนาดของฟอนต์สำหรับข้อความหัวข้อ
            ),
            const SizedBox(height: 10), // ระยะห่างระหว่างหัวข้อและกล่องตัวเลือก
            GestureDetector(
              onTap: _showOptionsDialog, // เรียกใช้ฟังก์ชันเมื่อคลิกที่กล่องตัวเลือก
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF), // สีพื้นหลังของกล่องตัวเลือก
                  borderRadius: BorderRadius.circular(8.0), // ความโค้งของมุมกล่องตัวเลือก
                  border: Border.all(color: const Color(0xFFd0d0d0), width: 1.0), // ขอบของกล่องตัวเลือก
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.selectedOption == 'None' ? 'Add Notifications...' : (widget.selectedOption ?? 'Add Notifications...'),
                      style: TextStyle(
                        fontSize: 16, // ขนาดของฟอนต์ในกล่องตัวเลือก
                        color: const Color(0xFF717273).withOpacity(0.6), // สีของข้อความในกล่องตัวเลือก
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