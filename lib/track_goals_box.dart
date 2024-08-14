import 'package:flutter/material.dart';

// StatefulWidget สำหรับแทร็กเป้าหมาย
class TrackGoals extends StatefulWidget {
  // รับค่าความก้าวหน้า (progress) และฟังก์ชันที่ใช้ในการแจ้งการเปลี่ยนแปลงของความก้าวหน้า
  final double progress;
  final ValueChanged<double> onProgressChanged;

  // คอนสตรัคเตอร์ของ TrackGoals
  const TrackGoals({
    super.key,
    required this.progress,
    required this.onProgressChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TrackGoalsState createState() => _TrackGoalsState();
}

class _TrackGoalsState extends State<TrackGoals> {
  // ตัวแปรสำหรับเก็บค่าของ Slider
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    // แปลงค่าความก้าวหน้า (progress) จากช่วง 0-1 ไปเป็นเปอร์เซ็นต์ (0-100)
    _sliderValue = widget.progress * 100.0; // Convert to percentage
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20.0, // ระยะห่างจากด้านซ้าย
        right: 20.0, // ระยะห่างจากด้านขวา
        top: 15.0, // ระยะห่างจากด้านบน
        bottom: 2.0, // ระยะห่างจากด้านล่าง
      ),
      decoration: BoxDecoration(
        color: Colors.white, // สีพื้นหลังของ Container
        borderRadius: BorderRadius.circular(15.0), // มุมโค้งมนของ Container
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // สีของเงาที่จางลง
            blurRadius: 5.0, // รัศมีเบลอของเงา
            offset: const Offset(0, 2), // การเลื่อนตำแหน่งของเงา
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // การจัดแนวเนื้อหาภายในแนวตั้ง
        children: <Widget>[
          const Text(
            'Track Goals', // ข้อความที่แสดง
            style: TextStyle(fontSize: 20), // ขนาดตัวอักษร
          ),
          const SizedBox(height: 10), // ระยะห่างระหว่างข้อความกับ Slider
          Row(
            children: <Widget>[
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor:
                        const Color(0xFF717273), // สีของแทร็กที่ใช้งานอยู่
                    inactiveTrackColor:
                        const Color(0xFFd0d0d0), // สีของแทร็กที่ไม่ใช้งาน
                    thumbColor: const Color(0xFF4c4949), // สีของลูกบอลบน Slider
                    overlayColor: const Color(0xFFd0d0d0)
                        .withAlpha(30), // สีของ overlay บน Slider เมื่อจับ
                    trackHeight: 10.0, // ความสูงของแทร็ก Slider
                  ),
                  child: Slider(
                    value: _sliderValue, // ค่าเริ่มต้นของ Slider
                    min: 0.0, // ค่าต่ำสุดของ Slider
                    max: 100.0, // ค่าสูงสุดของ Slider
                    divisions: 100, // จำนวนหน่วยที่แยก Slider
                    onChanged: (double value) {
                      setState(() {
                        // อัปเดตค่า _sliderValue และแจ้งการเปลี่ยนแปลงไปยังพาเรนต์
                        _sliderValue = value;
                        widget.onProgressChanged(value /
                            100.0); // แจ้งพาเรนต์ด้วยค่าที่ถูกปรับเป็นช่วง 0-1
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                  width: 10), // ระยะห่างระหว่าง Slider กับข้อความเปอร์เซ็นต์
              Text(
                '${_sliderValue.toStringAsFixed(0)}%', // แสดงเปอร์เซ็นต์ที่ได้จาก Slider
                style: const TextStyle(fontSize: 16), // ขนาดตัวอักษร
              ),
            ],
          ),
        ],
      ),
    );
  }
}
