import 'package:flutter/material.dart';

class TrackGoals extends StatefulWidget {
  @override
  _TrackGoals createState() => _TrackGoals();
}

class _TrackGoals extends State<TrackGoals> {
  double _sliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 1.0,   // ระยะห่างด้านซ้าย
        right: 50.0,  // ระยะห่างด้านขวา
        top: 15.0,    // ระยะห่างด้านบน
        bottom: 1.0, // ระยะห่างด้านล่าง
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFffffff),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center, // จัดตำแหน่งกลางในแนวตั้ง
        children: <Widget>[
          const Text(
            'Track Goals',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10), // เพิ่มระยะห่างระหว่างหัวข้อกับแถบเลื่อน
          Row(
            mainAxisAlignment: MainAxisAlignment.start, // ชิดแถบเลื่อนเข้ากับขอบทางด้านซ้าย
            crossAxisAlignment: CrossAxisAlignment.center, // จัดตำแหน่งกลางในแนวขวาง
            children: <Widget>[
              Expanded(
                child: FractionallySizedBox(
                  widthFactor: 0.9, // ขยายความกว้างของ slider ให้ใหญ่ขึ้น
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: const Color(0xFF717273), // สีของแถบเลื่อนเมื่อใช้งาน
                      inactiveTrackColor: const Color(0xFFd0d0d0), // สีของแถบเลื่อนเมื่อไม่ได้ใช้งาน
                      thumbColor: const Color(0xFF4c4949), // สีของลูกเลื่อน 
                      trackHeight: 15.0, // ความสูงของแถบเลื่อน
                    ),
                    child: Slider(
                      value: _sliderValue,
                      min: 0.0,
                      max: 100.0,
                      divisions: 100,
                      onChanged: (double value) {
                        setState(() {
                          _sliderValue = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 2), // ลดระยะห่างระหว่างแถบเลื่อนกับตัวเลข %
              Align(
                alignment: Alignment.center, // จัดข้อความให้อยู่ตรงกลางแนวตั้ง
                child: Padding(
                  padding: const EdgeInsets.only(left: -8.0), // ดึงข้อความเข้าไปใกล้แถบเลื่อน
                  child: Text(
                    '${_sliderValue.toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
